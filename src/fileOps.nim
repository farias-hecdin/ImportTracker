import os, re, strutils

#-- Crear un nuevo archivo
proc createNewFile*(name: string) =
  var fileName = open(name, fmWrite)
  defer: fileName.close
  fileName.write("")

#-- Buscar archivos determinados en un directorio
proc findFiles*(pattern: string, dir: string): seq[string] =
  var matches: seq[string]
  var reExt = re(pattern)

  for kind, path in walkDir(dir):
    if kind == pcFile and contains(path, reExt):
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
  var reNames, rePatt, reElem: Regex
  reNames = re(pattern & " (\\w+)")
  rePatt = re(pattern)
  reElem = re("^(\\w+)")

  var content: string = readFile(dir)
  var names, matches: seq[string]
  matches = findAll(content, reNames)

  if matches.len > 0:
    for elem in matches:
      content = replace(elem, rePatt, "").strip()
      add(names, findAll(content, reElem)[0])
  else:
    add(names, "")
  return names
