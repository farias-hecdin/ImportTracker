import std/[os, re, strutils]
import terms

#-- Crear un nuevo archivo
proc createNewFile*(name: string) =
  var fileName = open(name, fmWrite)
  defer: fileName.close
  fileName.write("")

#-- Buscar archivos determinados en un directorio
proc findFiles*(pattern, dir, recursive: string): seq[string] =
  var files: seq[string]
  var rePattern = re(pattern)

  for kind, path in walkDir(dir):
    if kind == pcFile and contains(path, rePattern):
      add(files, path)
    elif kind == pcDir and recursive == "on":
      add(files, findFiles(pattern, path, recursive))
  return files

#-- Obtener los nombres de archivos de una lista de rutas
proc getFileName*(paths: seq[string]): seq[string] =
  var names: seq[string]

  for elem in paths:
    add(names, splitFile(elem).name)
  return names

#-- Leer el contenido de un archivo
proc readFileContent(fileDir: string): string =
  var content = readFile(fileDir)
  return content

#-- Buscar coincidencias
proc findMatches(fileContent: string, keywords: seq[string]): seq[string] =
  var matches: seq[string]

  for keyword in keywords:
    add(matches, findAll(fileContent, re(keyword & " (\\w+)")))
  return matches

#-- Procesar las coincidencias encontradas
proc processMatches(fileContent: string, matches: seq[string], keywords: seq[string]): seq[string] =
  var identifiers: seq[string]
  var content = fileContent

  for keyword in keywords:
    let reKeyword = re(keyword)
    for expression in matches:
      if contains(expression, reKeyword):
        content = replace(expression, keyword, "").strip()
        add(identifiers, content)
  return identifiers

#-- Obtener todos los nombres de los elementos de exportacion
proc getIdentifiers*(fileDir: string, pattern: string): seq[string] =
  var identifiers: seq[string]
  var fileContent = readFileContent(fileDir)
  var keywords = terms.extractTerm(pattern)
  var matches = findMatches(fileContent, keywords)

  if matches.len == 0:
    add(identifiers, "")
    return identifiers

  identifiers = processMatches(fileContent, matches, keywords)
  return identifiers

