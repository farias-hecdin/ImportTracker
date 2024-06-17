import colorize
import strutils
import fileOps as fops

var numberComponents*: int = 0

#-- Procesar todos los archivos y generar las importaciones
proc generateImports(pattern, dir, extension: string): (seq[string], seq[string]) =
  var importsListing, componentsListing: seq[string]
  var extensionFile: string  = extension
  var counter: int = 0

  # Crear un string que contenga cada ruta con sus componentes
  var filesFound: seq[string] = fops.findFiles(extensionFile, dir)

  if filesFound == @[]:
    echo (" No files found. \n").fgRed
    numberComponents = counter
    return

  for path in filesFound:
    var nameOfComponents = fops.extractFunctionName(path, pattern)
    # Validar la lista de componentes
    if nameOfComponents[0] != "":
      echo (" ├─ $1 ($2)" % [path, $nameOfComponents.len]).fgDarkGray

      var lineOfComponents: string = join(nameOfComponents, ", ")
      add(componentsListing, nameOfComponents)
      add(importsListing, "import { $1 } from \"$2\";" % [lineOfComponents, path])
      inc counter

  numberComponents = counter
  return (importsListing, componentsListing)

#-- Escribir en el archivo index
proc writeInIndexFile(file, line: string) =
  let file = open(file, fmAppend)
  defer: file.close()
  file.write(line & "\n")

#-- Inicializar "--parse <pattern>"
proc parse*(values: seq[string]) =
  let defaults: seq[string] = @["export default function", "./", "jsx"]
  var args: seq[string] = values & defaults[values.len..^1]
  var pattern = "\\b\\." & args[2] & "\\b"

  # Generar las importaciones y un nuevo archivo
  var (importsListing, componentListing) = generateImports(args[0], args[1], pattern)
  var file: string = "index." & args[2]

  if numberComponents != 0:
    fops.createNewFile(file)

    for elem in importsListing:
      writeInIndexFile(file, elem)
    for elem in @["", "export {"]:
      writeInIndexFile(file, elem)
    for elem in componentListing:
      writeInIndexFile(file, "  " & elem & ",")
    writeInIndexFile(file, "}")
  else:
    return
