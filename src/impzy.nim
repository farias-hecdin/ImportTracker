import std/[os, times, strutils], pkg/[cmdos]
import impzy/["cli", "parser", "/helpers/prints"]

proc main() =
  const errorMsg = "Operation invalid.\n"

  if paramCount() > 0:
    showVersion(cli[0].version)
    case paramStr(1):
      of "-h", "--help":
        echo helpMsg
      of "parse":
        let values = processArgs(cli.parser, true)
        prints.text(bold, "Initializing...")
        parser.commParser(values)
      else:
        echo errorMsg
  else:
    echo errorMsg

#-- Run script
when isMainModule:
  let timeStart = cpuTime()
  main()

  if parser.numberComponents > 0:
    let executionTime = ((cpuTime() - timeStart) * 1000).formatFloat(ffDecimal, 2)
    prints.text(bold, "\n Total:")
    prints.text(gray, " $# elements indexed in $# ms.\n", [$numberComponents, executionTime])

