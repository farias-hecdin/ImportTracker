import std/[strutils, strformat], pkg/[tinyre, cmdos]
import helpers/["files", "terms", "prints"]

var numberComponents* = 0
var recursiveArg, hideMsg: string

#-- Procesar todos los archivos y generar las importaciones
proc generateImports(pattern, dir, extension: string): (seq[string], seq[string]) =
  var reIndexPatt = tinyre.re"index."

  # Obtener una lista de archivos y validarla
  var filesFound = files.findFiles(extension, dir, recursiveArg)
  if filesFound.len == 0 or (filesFound.len == 1 and tinyre.contains(filesFound[0], reIndexPatt)):
    prints.text(red, "  No files found." & "\n")
    return

  # Verificar que el término de búsqueda sea válido
  if terms.validateTermSearch(pattern) == false:
    prints.text(red, "  Invalid pattern." & "\n")
    return

  # Procesar cada archivo encontrado y validar su contenido
  var importsListing, componentsListing: seq[string]
  var textFragment, lineComponents: string
  var reConditional = tinyre.re"default"

  for path in filesFound:
    if tinyre.contains(path, reIndexPatt):
      continue

    let nameComponents = files.getIdentifiers(path, pattern)
    if nameComponents[0] != "":
      # Contar el numero de elementos encontrados
      var number = nameComponents.len
      numberComponents += number

      # Mostrar los elementos exportados
      if hideMsg != "off": prints.text(pink, "  $1 ($2 exports)", [path, $number]) else: discard

      # Generar una linea de texto con los elementos exportados
      lineComponents = nameComponents.join(", ")
      if tinyre.contains(pattern, reConditional):
        textFragment = "import $1 from \"./$2\";" % [lineComponents, path]
      else:
        textFragment = "import { $1 } from \"./$2\";" % [lineComponents, path]

      add(componentsListing, nameComponents)
      add(importsListing, textFragment)
    else:
      if hideMsg != "off": prints.text(graydark, "  $1 (No elements found)", [path]) else: discard

  return (importsListing, componentsListing)

#-- Escribir en el archivo index
proc appendLine(file: File, line: string) =
  file.write(line & "\n")

proc generateIndexFile(file: string, imports, components: seq[string]) =
  let f = open(file, fmWrite)
  defer: f.close()

  for elem in imports:
    appendLine(f, elem)
  appendLine(f, "")
  appendLine(f, "export {")

  for elem in components:
    appendLine(f, &"  {elem},")
  appendLine(f, "}")

#-- Inicializar "--parse [options]"
proc commParse*(val: CmdosData) =
  var term      = val[0].data[1]
  var directory = val[1].data[1]
  var extension = val[2].data[1]
  recursiveArg  = val[3].data[1]
  hideMsg       = val[4].data[1]

  # Generar las importaciones
  var pattExtension = "\\b.$1\\b" % [extension]
  var file = &"index.{extension}"
  var (importsListing, componentsListing) = generateImports(term, directory, pattExtension)

  if numberComponents == 0:
    return

  # Crear un nuevo archivo
  createNewFile(file)
  # Añadir los datos encontrado al archivo
  let imports = importsListing
  let components = componentsListing
  generateIndexFile(file, imports, components)

