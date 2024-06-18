import os, times, strutils
import colorize
import src/tasks as mTsk
import src/cmdos as mCmd

const version: string = "v2.0.1"

#-- Mostrar un mensaje de ayuda
proc showHelp() =
  echo (" Usage:").bold
  echo ("   impzy [parse] [dir] [ext]").fgLightGray
  echo ("   impzy [options]").fgLightGray
  echo ""
  echo (" Parse:").bold
  echo ("   --parse <expression>  Specify the export pattern (e.g. \"export default function {{name}}\").").fgLightGray
  echo ("   --dir <path>          Specify a directory (default: \"./\").").fgLightGray
  echo ("   --ext <value>         Specifies the index file extension (default: \".jsx\").").fgLightGray
  echo ""
  echo (" Options:").bold
  echo ("   --help                Display this help message and exit.").fgLightGray
  echo ""
  echo (" Examples:").bold
  echo ("   impzy --parse \"export default function\" --dir \"./src/components\" --ext \".jsx\"").fgLightGray
  echo ""

#-- Inicializar el programa
const commandPatterns: seq[seq[string]] = @[
  @["--parse"],
  @["--parse", "--dir"],
  @["--parse", "--dir", "--ext"],
]

proc run() =
  echo " $1 $2\n" % [(" impzy ").fgBlack.bgGreen, (version).fgGreen]

  if paramCount() > 0:
    case paramStr(1):
      of "--help":
        showHelp()
      of "--parse":
        echo (" Initializing...").bold
        var pairValues: (seq[string], seq[string]) = mCmd.extractArgsInputPairs()
        mCmd.processUserInput(commandPatterns, mTsk.parse, pairValues)
  else:
    showHelp()

#-- Run script
let timeStart: float = cpuTime()
run()

if numberComponents != 0:
  let executionTime: string = ((cpuTime() - timeStart) * 1000).formatFloat(ffDecimal, 3)
  echo (" $1 elements indexed in $2 ms. \n").bold % [$numberComponents, executionTime]

