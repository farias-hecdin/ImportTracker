import colorize
import strutils
import fileOps

var g_numberComponents*: int = 0

#-- Procesar todos los archivos y generar las importaciones
proc generateImports(pattern, dir, extension: string): (seq[string], seq[string]) =
  var importsListing, componentsListing, filesFound, nameOfComponents: seq[string]
  var extensionFile, lineOfComponents: string  = extension
  var counter: int = 0

  # Crear un string que contenga cada ruta con sus componentes
  filesFound = g_findFiles(extensionFile, dir)

  if filesFound == @[]:
    echo (" No files found. \n").fgRed
    g_numberComponents = counter
    return

  for path in filesFound:
    nameOfComponents = g_extractFunctionName(path, pattern)
    # Validar la lista de componentes
    if nameOfComponents[0] != "":
      echo (" ├─ $1 ($2)" % [path, $nameOfComponents.len]).fgDarkGray

      lineOfComponents = join(nameOfComponents, ", ")
      add(componentsListing, nameOfComponents)
      add(importsListing, "import { $1 } from \"$2\";" % [lineOfComponents, path])
      inc counter

  g_numberComponents = counter
  return (importsListing, componentsListing)

#-- Escribir en el archivo index
proc writeInIndexFile(file, line: string) =
  let file = open(file, fmAppend)
  defer: file.close()
  file.write(line & "\n")

#-- Inicializar "--parse <pattern>"
proc g_commParse*(values: seq[string]) =
  var pattDir, dir, ext: string
  pattDir = values[0]
  dir = values[1]
  ext = values[2]

  # Generar las importaciones y un nuevo archivo
  var file, pattExt: string
  pattExt ="\\b.$1\\b" % [values[2]]
  file = "index.$1" % [ext]
  var (importsListing, componentListing) = generateImports(pattDir, dir, pattExt)

  if g_numberComponents != 0:
    g_createNewFile(file)

    for elem in importsListing:
      writeInIndexFile(file, elem)
    for elem in @["", "export {"]:
      writeInIndexFile(file, elem)
    for elem in componentListing:
      writeInIndexFile(file, "  $1," % [elem])
    writeInIndexFile(file, "}")
  else:
    return

