import std/[strutils, re]
import pkg/tinyre
import file_ops

#-- Buscar coincidencias
proc findMatches(content: string, keywords: seq[string]): seq[string] =
  for keyword in keywords:
    let regex = re.re(keyword & " (\\w+)")
    result.add(re.findAll(content, regex))

#-- Procesar las coincidencias encontradas
proc processMatches(content: string, matches: seq[string], keywords: seq[string]): seq[string] =
  for keyword in keywords:
    let regex = tinyre.re(keyword)
    for match in matches:
      if tinyre.contains(match, regex):
        result.add(tinyre.replace(match, regex, "").strip())

#-- Obtener todos los nombres de los elementos de exportacion
proc getIdentifiers*(fileDir: string, keywords: seq[string]): seq[string] =
  let content = readFileContent(fileDir)
  let matches = findMatches(content, keywords)

  if matches.len == 0: result.add("")
  result.add(processMatches(content, matches, keywords))
