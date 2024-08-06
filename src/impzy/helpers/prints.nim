import std/[strutils, strformat], pkg/[NimColor]

#-- Estilos
const
  bold* = "bold;"
  gray* = "e0e0e0;"
  graydark* = "666666;"
  red* = "d84646;"
  pink* = "b844cf;"
  green* = "efd12a;"
  black* = "000000;"

#-- Estilar un texto
proc text*(style, message: string, values: openArray[string] = []) =
  if (values.len == 0): echo (&"&{style}{message}").color
  else: echo (&"&{style}{message}").color % values

#-- Mostrar la version del app
proc showVersion*(version: string) =
  echo (&"&{black}&bg{green} impzy ").color & (&"&{green} {version}").color & "\n"

