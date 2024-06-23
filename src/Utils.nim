import re, strutils

#-- Unir el termino de busqueda con los elementos predeterminados
proc completeTerm*(input: string): seq[string] =
  const keywords = @["var", "let", "const", "function", "class"]
  var inputWithoutAsterisk = input[0..^2]
  var terms: seq[string]

  for keyword in keywords:
    add(terms, inputWithoutAsterisk & keyword)
  return terms

#-- Extraer los terminos de busqueda
proc extractTerm*(input: string): seq[string] =
  var terms: seq[string]

  if contains(input, re"\*"):
    add(terms, completeTerm(input))
  else:
    add(terms, input)
  return terms

#-- Verificar el terminos de busqueda ingresado
proc validateTermSearch*(input: string): bool =
  const specials = @["export *", "export default *"]
  var terms: seq[string]
  var found: bool

  for elem in specials:
    add(terms, completeTerm(elem))

  for term in (terms & specials):
    if input.strip() == term:
      found = true
      break
    else:
      found = false
  return found
