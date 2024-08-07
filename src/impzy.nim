import std/[os, times, strutils], pkg/[cmdos]
import impzy/["command", "parse", "/helpers/prints"]

proc main() =
  const errorMsg = "Operation invalid.\n"
  const vers = cli.version

  if paramCount() > 0:
    showVersion(vers)
    case paramStr(1):
      of "-h", "--help":
        echo helpMsg
      of "-v", "--version":
        echo ""
      of "parse":
        let values = processArgs(command.parse, true)
        prints.text(bold, "Initializing...")
        parse.commParse(values)
      else:
        echo errorMsg
  else:
    echo errorMsg

#-- Run script
when isMainModule:
  let timeStart = cpuTime()
  main()

  if parse.numberComponents >= 0:
    let executionTime = ((cpuTime() - timeStart) * 1000).formatFloat(ffDecimal, 2)
    prints.text(bold, "\nTotal:")
    prints.text(gray, "$1 elements indexed in $2 ms.\n", [$numberComponents, executionTime])

