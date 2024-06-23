import os, times, strutils
import colorize
import "./src/ui/Prints", "./src/core/Parse", "./src/vendor/Cmdos"

const version = "v2.1.0"

#-- Inicializar el programa
var parse: Cmdos
parse = Cmdos(
  arguments: @["--parse", "--dir", "--ext"],
  values: @["export default function", "./", "jsx"],
)

proc run() =
  Prints.showVersion(version)
  if paramCount() > 0:
    case paramStr(1):
      of "--help":
        Prints.showHelp()
      of "--parse":
        echo (" Initializing...").bold
        var inputPairs: seq[string] = Cmdos.extractPairs(Cmdos.processArgsInputs(parse))
        Parse.commParse(inputPairs)
  else:
    Prints.showHelp()

#-- Run script
let timeStart = cpuTime()
run()

if Parse.numberComponents != 0:
  let executionTime = ((cpuTime() - timeStart) * 1000).formatFloat(ffDecimal, 2)
  echo ("\n Total: $1 elements indexed in $2 ms. \n").bold % [$Parse.numberComponents, executionTime]

