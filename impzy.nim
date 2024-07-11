import std/[os, times, strutils]
import cmdos
import "./src/ui/Prints", "./src/core/Parse"

const version = "v2.2"

#-- Inicializacion del script
var parse = Cmdos(
  args: @[
    Arg(short: "-p", long: "--parse"),
    Arg(short: "-d", long: "--dir", default: "./"),
    Arg(short: "-e", long: "--ext", default: "jsx"),
    Arg(short: "-r", long: "--recursive", default: "off"),
  ]
)

proc run() =
  Prints.showVersion(version)
  if paramCount() > 0:
    case paramStr(1):
      of "-h", "--help":
        Prints.showHelp()
      of "-p", "--parse":
        Prints.text(bold, " Initializing...")
        var (_, values) = extractPairs(processArgs(parse))
        Parse.commParse(values)
  else:
    Prints.showHelp()

#-- Run script
let timeStart = cpuTime()
run()

if Parse.numberComponents != 0:
  let executionTime = ((cpuTime() - timeStart) * 1000).formatFloat(ffDecimal, 2)
  Prints.text(bold, "\n Total:")
  Prints.text(gray, " $# elements indexed in $# ms. \n", [$numberComponents, executionTime])
