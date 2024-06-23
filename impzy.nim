import std/[os, times, strutils]
import "./src/ui/Prints", "./src/core/Parse", "./src/vendor/Cmdos"

const version = "v2.1"

#-- Inicializacion del script
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
        Prints.text(bold, " Initializing...")
        var inputPairs: seq[string] = Cmdos.extractPairs(Cmdos.processArgsInputs(parse))
        Parse.commParse(inputPairs)
  else:
    Prints.showHelp()

#-- Run script
let timeStart = cpuTime()
run()

if Parse.numberComponents != 0:
  let executionTime = ((cpuTime() - timeStart) * 1000).formatFloat(ffDecimal, 2)
  Prints.text(bold, "\n Total:")
  Prints.text(gray, " $# elements indexed in $# ms. \n", [$numberComponents, executionTime])
