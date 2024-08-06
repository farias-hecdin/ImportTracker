import std/[strutils], pkg/[tinyre]

#-- Unir el termino de busqueda con los elementos predeterminados
proc completeTerm*(input: string): seq[string] =
  const keywords = ["var", "let", "const", "function", "class"]
  var inputWithoutAsterisk = input[0..^2]
  var terms: seq[string]

  for keyword in keywords:
    add(terms, inputWithoutAsterisk & keyword)
  return terms

#-- Extraer los terminos de busqueda
proc extractTerm*(input: string): seq[string] =
  var terms: seq[string]

  if tinyre.contains(input, tinyre.re"\*"):
    add(terms, completeTerm(input))
  else:
    add(terms, input)
  return terms

#-- Verificar el terminos de busqueda ingresado
proc validateTermSearch*(input: string): bool =
  proc loopFillTerms(listing: seq[string]): seq[string] =
    for elem in listing:
      result.add(completeTerm(elem))

  const specialTerms = @["export *", "export default *"]
  const terms: seq[string] = loopFillTerms(specialTerms)
  var found: bool

  for term in (terms & specialTerms):
    if input.strip() == term:
      found = true
      break
    else:
      found = false
  return found
