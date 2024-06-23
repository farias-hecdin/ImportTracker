import colorize
import strutils, re
import "../manage/Files", "../Utils"

var numberComponents* = 0

#-- Procesar todos los archivos y generar las importaciones
proc generateImports(pattern, dir, extension: string): (seq[string], seq[string]) =
  # Obtener una lista de archivos y validarla
  var filesFound = Files.findFiles(extension, dir)
  if len(filesFound) == 0:
    echo ("   No files found. \n").fgRed
    return

  # Verificar que el término de búsqueda sea válido
  if Utils.validateTermSearch(pattern) == false:
    echo ("   Invalid pattern.\n").fgRed
    return

  # Procesar cada archivo encontrado y validar su contenido
  var importsListing, componentsListing: seq[string]
  var textFragment, lineComponents: string
  var reConditional = re"default"

  for path in filesFound:
    if contains(path, "index"):
      continue

    var nameComponents = Files.getIdentifiers(path, pattern)
    if nameComponents[0] != "":
      # Contar el numero de elementos encontrados
      var number =len(nameComponents)
      numberComponents += number

      # Mostrar los elementos exportados
      echo ("   $1 ($2 exports)" % [path, $number]).fgLightMagenta

      # Generar una linea de texto con los elementos exportados
      lineComponents = join(nameComponents, ", ")
      if contains(pattern, reConditional):
        textFragment = "import $1 from \"./$2\";" % [lineComponents, path]
      else:
        textFragment = "import { $1 } from \"./$2\";" % [lineComponents, path]

      add(componentsListing, nameComponents)
      add(importsListing, textFragment)

  return (importsListing, componentsListing)

#-- Escribir en el archivo index
proc writeInIndexFile(file, line: string) =
  let file = open(file, fmAppend)
  defer: file.close()
  file.write(line & "\n")

#-- Inicializar "--parse <pattern>"
proc commParse*(values: seq[string]) =
  var term = values[0]
  var directory = values[1]
  var extension = values[2]

  # Generar las importaciones
  var pattExtension = "\\b.$1\\b" % [extension]
  var file = "index.$1" % [extension]
  var (importsListing, componentsListing) = generateImports(term, directory, pattExtension)

  if numberComponents == 0:
    return

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

