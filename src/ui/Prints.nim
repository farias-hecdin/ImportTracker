import std/strutils
import NimColor

const bold* = "bold"
const gray* = "e0e0e0"
const red* = "d84646"
const pink* = "b844cf"
const green* = "efd12a"

#-- Estilar un texto
proc text*(style: string, message: string, values: openArray[string] = []) =
  let styled = "&" & style & ";"

  if len(values) == 0: echo (styled & message).color
  else: echo (styled & message).color % values

#-- Mostrar la version del app
proc showVersion*(version: string) =
  let bgColor = "&000000;&bg" & green & ";"
  echo " $1 $2\n" % [(bgColor & " impzy ").color, ("&" & green & ";" & version).color]

#-- Mostrar un mensaje de ayuda
proc showHelp*() =
  text(bold, " Usage:")
  text(gray, "   impzy [parse] [dir] [ext]")
  text(gray, "   impzy [options]")
  echo ""
  text(bold, " Parse:")
  text(gray, "   --parse <expression>  Specify the export pattern (e.g. \"export default function {{name}}\").")
  text(gray, "   --dir <path>          Specify a directory (default: \"./\").")
  text(gray, "   --ext <value>         Specifies the index file extension (default: \".jsx\").")
  echo ""
  text(bold, " Options:")
  text(gray, "   --help                Display this help message and exit.")
  echo ""
  text(bold, " Examples:")
  echo ""
  text(gray, "   impzy --parse \"export default function\" --dir \"./src/components\" --ext \".jsx\" \n")

