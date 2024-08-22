import std/[os, strutils, times]
import pkg/[cmdos, hex2ansi]
import impzy/[cli_setup, text_styled, parse_command]

proc main(): bool =
  var showTime = false

  if paramCount() > 0:
    headingText("2.5.1")
    case paramStr(1):
      of "-h", "--help":
        echo helpMsg
      of "parse":
        let (flags, args) = processCmd(parseCmd)
        showTime = initParseCommand(flags, args)
      else: errorTextAndExit("operation invalid.")
  result = showTime

#-- Run script
when isMainModule:
  let start = cpuTime()
  let showTime = main()
  let count = $parse_command.exportedComponents
  let indexed = $parse_command.indexedFiles

  if showTime:
    let time = ((cpuTime() - start)).formatFloat(ffDecimal, 2)
    echo "\n\n$#Summary:$#" % [underline, nostyle]
    echo "  Total elements indexed: $#/$#" % [count, indexed]
    echo "  Time taken: $#s" % [time]
