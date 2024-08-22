import std/os
import pkg/tinyre
import text_styled

#-- Obtener los nombres de archivos de una lista de rutas
proc getFileName*(paths: seq[string]): seq[string] =
  for elem in paths:
    result.add(splitFile(elem).name)

#-- Leer el contenido de un archivo
proc readFileContent*(fileDir: string): string =
  result = readFile(fileDir)

#-- Crear un nuevo archivo
proc createNewFile*(name: string) =
  var fileName = open(name, fmWrite)
  defer: fileName.close
  fileName.write("")

#-- Escribir una línea de texto en un archivo
proc appendLine*(file: File, line: string) =
  file.write(line & "\n")

#-- Buscar archivos determinados en un directorio
var reExt: Re

proc findFiles*(extension, dir: string, recursive: bool, fixed: bool = false): seq[string] =
  let indexPattern = re"index\."

  if not fixed:
    case extension:
      of "js": reExt = re"\.js$"
      of "jsx": reExt = re"\.jsx$"
      of "ts": reExt = re"\.ts$"
      of "tsx": reExt = re"\.tsx$"
      else: errorTextAndExit("Invalid extension.")

  for kind, path in walkDir(dir):
    if kind == pcFile and path.find(reExt) > 0:
      if path.find(indexPattern) > 0: continue
      else: result.add(path)
    elif kind == pcDir and recursive:
      result.add(findFiles(extension, path, recursive, true))
