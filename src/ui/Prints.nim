import strutils
import colorize

#-- Mostrar un mensaje de ayuda
proc showHelp*() =
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

proc showVersion*(version: string) =
  echo " $1 $2\n" % [(" impzy ").fgBlack.bgGreen, (version).fgGreen]
