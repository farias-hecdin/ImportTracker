import os, re, strutils

#-- Crear un nuevo archivo
proc createNewFile*(name: string) =
  var fileName = open(name, fmWrite)
  defer: fileName.close
  fileName.write("")

#-- Buscar archivos determinados en un directorio
proc findFiles*(pattern: string, dir: string): seq[string] =
  var matches: seq[string]

  for kind, path in walkDir(dir):
    if kind == pcFile and contains(path, re(pattern)):
      add(matches, path)
    elif kind == pcDir:
      add(matches, findFiles(pattern, path))
  return matches

#-- Obtener los nombres de archivos de una lista de rutas
proc getFileName*(paths: seq[string]): seq[string] =
  var values: seq[string]
  var fileName: string

  for elem in paths:
    fileName = splitFile(elem).name
    add(values, fileName)
  return values

#-- Extraer los nombres de funciones de un archivo según un patrón
proc extractFunctionName*(dir: string, pattern: string): seq[string] =
  var regex: Regex = re(pattern & " (\\w+)")
  var content: string = readFile(dir)
  var matches: seq[string] = findAll(content, regex)
  var names: seq[string]

  if matches.len > 0:
    for elem in matches:
      content = replace(elem, re(pattern), "").strip()
      add(names, findAll(content, re("^(\\w+)"))[0])
  else:
    add(names, "")
  return names
