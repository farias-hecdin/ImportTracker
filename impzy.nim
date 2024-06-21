import os, times, strutils
import colorize
import src/tasks, src/cmdos

const version: string = "v2.0.2"

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
var parse: Cmdos
parse = Cmdos(
  arguments: @["--parse", "--dir", "--ext"],
  values: @["export default function", "./", "jsx"],
)

proc run() =
  echo " $1 $2\n" % [(" impzy ").fgBlack.bgGreen, (version).fgGreen]

  if paramCount() > 0:
    case paramStr(1):
      of "--help":
        showHelp()
      of "--parse":
        echo (" Initializing...").bold
        var ArgInputPairs = g_extractPairs(parse.g_processArgsInputs())
        g_commParse(ArgInputPairs)
  else:
    showHelp()

#-- Run script
let timeStart: float = cpuTime()
run()

if g_numberComponents != 0:
  let executionTime: string = ((cpuTime() - timeStart) * 1000).formatFloat(ffDecimal, 3)
  echo (" $1 elements indexed in $2 ms. \n").bold % [$g_numberComponents, executionTime]

