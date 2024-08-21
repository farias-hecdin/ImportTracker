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
proc findFiles*(extension, dir: string, recursive: bool): seq[string] =
  let indexPattern = re"index\."
  var regex: Re
  case extension:
    of "js": regex = re"\.js$"
    of "jsx": regex = re"\.jsx$"
    of "ts": regex = re"\.ts$"
    of "tsx": regex = re"\.tsx$"
    else: errorTextAndExit("Invalid extension.")

  for kind, path in walkDir(dir):
    if kind == pcFile and path.find(regex) > 0:
      if path.find(indexPattern) > 0: continue
      else: result.add(path)
    elif kind == pcDir and recursive:
      result.add(findFiles(extension, path, recursive))
