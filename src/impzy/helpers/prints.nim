import std/[strutils, strformat], pkg/[NimColor]

const bold* = "bold;"
const gray* = "e0e0e0;"
const graydark* = "666666;"
const red* = "d84646;"
const pink* = "b844cf;"
const green* = "efd12a;"
const black* = "000000;"

#-- Estilar un texto
proc text*(style, message: string, values: openArray[string] = []) =
  if values.len == 0:
    echo (&"&{style}{message}").color
  else:
    echo (&"&{style}{message}").color % values

#-- Mostrar la version del app
proc showVersion*(version: string) =
  echo (&"&{black}&bg{green} impzy ").color & (&"&{green} {version}").color & "\n"

