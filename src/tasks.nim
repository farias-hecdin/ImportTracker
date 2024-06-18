import colorize
import strutils
import fileOps as fops

var numberComponents*: int = 0

#-- Procesar todos los archivos y generar las importaciones
proc generateImports(pattern, dir, extension: string): (seq[string], seq[string]) =
  var importsListing, componentsListing, filesFound, nameOfComponents: seq[string]
  var extensionFile, lineOfComponents: string  = extension
  var counter: int = 0

  # Crear un string que contenga cada ruta con sus componentes
  filesFound = fops.findFiles(extensionFile, dir)

  if filesFound == @[]:
    echo (" No files found. \n").fgRed
    numberComponents = counter
    return

  for path in filesFound:
    nameOfComponents = fops.extractFunctionName(path, pattern)
    # Validar la lista de componentes
    if nameOfComponents[0] != "":
      echo (" ├─ $1 ($2)" % [path, $nameOfComponents.len]).fgDarkGray

      lineOfComponents = join(nameOfComponents, ", ")
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
  var defaults, args: seq[string]
  defaults = @["export default function", "./", "jsx"]
  args = values & defaults[values.len..^1]

  # Generar las importaciones y un nuevo archivo
  var pattern, file: string
  pattern = "(\\.$1)" % [args[2]]
  file = "index.$1" % [args[2]]
  var (importsListing, componentListing) = generateImports(args[0], args[1], pattern)

  if numberComponents != 0:
    fops.createNewFile(file)

    for elem in importsListing:
      writeInIndexFile(file, elem)
    for elem in @["", "export {"]:
      writeInIndexFile(file, elem)
    for elem in componentListing:
      writeInIndexFile(file, "  $1," % [elem])
    writeInIndexFile(file, "}")
  else:
    return
