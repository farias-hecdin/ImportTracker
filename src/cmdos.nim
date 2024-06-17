import os
import colorize

#-- Extraer el valor de los argumentos
proc extractArgsInputPairs*(): (seq[string], seq[string]) =
  var argumentPair, inputPair: seq[string]

  for num in 1..paramCount():
    if num %% 2 == 0:
      add(inputPair, paramStr(num))
    else:
      add(argumentPair, paramStr(num))
  return (argumentPair, inputPair)

#-- Procesar las entradas de usuario
proc processUserInput*[
  T: string | (seq[string], seq[string]),
  U: string | seq[string]
] (commandPatterns: seq[seq[string]], task: proc(x: U), input: T) =
  var isValid: bool = false

  when input is string:
    isValid = true
  when input is tuple:
    var (argumentPair, inputPair) = input

    for pattern in commandPatterns:
      if pattern == argumentPair and argumentPair.len == inputPair.len:
        isValid = true

  if isValid:
    task(inputPair)
  else:
    echo (" Invalid option.\n").fgRed
