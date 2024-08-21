import std/strutils
import pkg/tinyre

#-- Unir el termino de busqueda con los elementos predeterminados
proc completeTerm*(input: string): seq[string] =
  const keywords = ["var", "let", "const", "function", "class"]
  let inputWithoutAsterisk = input[0..^2]
  for keyword in keywords: result.add(inputWithoutAsterisk & keyword)

#-- Extraer los terminos de busqueda
proc extractTerm*(input: string): seq[string] =
  if input.contains(re"\*"): result.add(completeTerm(input))
  else: result.add(input)

#-- Verificar el terminos de busqueda ingresado
proc loopFillTerms(listing: seq[string]): seq[string] {.inline.} =
  for elem in listing: result.add(completeTerm(elem))

proc validateTermSearch*(input: string): bool =
  const specialTerms = @["export *", "export default *"]
  const terms: seq[string] = loopFillTerms(specialTerms)

  for term in (terms & specialTerms):
    if input.strip() == term:
      result = true
      break
    else: result = false
