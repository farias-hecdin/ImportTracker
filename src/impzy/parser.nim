import std/[strutils], pkg/[tinyre, cmdos]
import helpers/["files", "terms", "prints"]

var numberComponents* = 0
var recursiveArg: string

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
  var reConditional = tinyre.re("default")

  for path in filesFound:
    if tinyre.contains(path, reIndexPatt):
      continue

    let nameComponents = files.getIdentifiers(path, pattern)
    if nameComponents[0] != "":
      # Contar el numero de elementos encontrados
      var number = nameComponents.len
      numberComponents += number

      # Mostrar los elementos exportados
      prints.text(pink, "  $1 ($2 exports)", [path, $number])

      # Generar una linea de texto con los elementos exportados
      lineComponents = join(nameComponents, ", ")
      if tinyre.contains(pattern, reConditional):
        textFragment = "import $1 from \"./$2\";" % [lineComponents, path]
      else:
        textFragment = "import { $1 } from \"./$2\";" % [lineComponents, path]

      add(componentsListing, nameComponents)
      add(importsListing, textFragment)
    else:
      prints.text(graydark, "  $1 (No elements found)", [path])

  return (importsListing, componentsListing)

#-- Escribir en el archivo index
proc writeInIndexFile(file, line: string) =
  let file = open(file, fmAppend)
  defer: file.close()
  file.write(line & "\n")

#-- Inicializar "--parser <pattern>"
proc commParser*(values: CmdosData) =
  var term = values[0].data[1]
  var directory = values[1].data[1]
  var extension = values[2].data[1]
  recursiveArg = values[3].data[1]

  echo term, directory
  # Generar las importaciones
  var pattExtension = "\\b.$1\\b" % [extension]
  var file = "index.$1" % [extension]
  var (importsListing, componentsListing) = generateImports(term, directory, pattExtension)

  if numberComponents == 0: return

  # Crear un nuevo archivo
  createNewFile(file)

  # Añadir los datos encontrado al archivo
  for elem in importsListing:
    writeInIndexFile(file, elem)
  for elem in @["", "export {"]:
    writeInIndexFile(file, elem)
  for elem in componentsListing:
    writeInIndexFile(file, "  $1," % [elem])

  writeInIndexFile(file, "}")

