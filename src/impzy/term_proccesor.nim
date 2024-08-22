import std/strutils

#-- Unir el termino de busqueda con los elementos predeterminados
proc completeTerm*(input: string): seq[string] =
  const primitive = @["var", "let", "const"]
  const keywords = @["function", "class"] & primitive

  let prefix = if input == "*": "export " else: input[0..^2]

  for keyword in keywords:
    if input == "*" and keyword in ["function", "class"]:
      result.add("export default " & keyword)
    elif input == "export default *" and keyword in primitive:
      continue
    result.add(prefix & keyword)

#-- Extraer los terminos de busqueda
proc extractTerm*(input: string): seq[string] =
  const patterns = @["*", "export *", "export default *"]

  case input:
  of patterns[0]:
    const t = completeTerm(patterns[0])
    result.add(t)
  of patterns[1]:
    const t = completeTerm(patterns[1])
    result.add(t)
  of patterns[2]:
    const t = completeTerm(patterns[2])
    result.add(t)
  else:
    result.add(input)

#-- Verificar el terminos de busqueda ingresado
proc loopFillTerms(listing: seq[string]): seq[string] =
  for elem in listing: result.add(completeTerm(elem))

proc validateTermSearch*(input: string): bool =
  const specialTerms = @["export *", "export default *"]
  const terms: seq[string] = loopFillTerms(specialTerms)

  for term in (@["*"] & terms & specialTerms):
    if input.strip() == term:
      result = true
      break
    else: result = false
