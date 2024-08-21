import std/[strutils, strformat]
import pkg/hex2ansi

#-- Estilos y colores
const
  nostyle* = "\e[0m"
  bold* = "\e[1;97m"
  underline* =  bold & "\e[4;37m"
  gray* = "#e0e0e0;"
  graydark* = "#666666;"
  red* = "#d84646;"
  green* = "#efd12a;"
  black* = "#000000;"

#-- Mostrar un msj de bienvenida
proc headingText*(version: static string) =
  const text = "$4$3 impzy $2 $5$1$2\n" % [version, nostyle, fg(black), bg(green), fg(green)]
  stdout.writeLine(text)

#-- Mostrar un mensaje de error y detener el programa
proc errorTextAndExit*(msg: static string) =
  const text = "$1$3Error:$2 $4" % [bold, nostyle, fg(red), msg]
  stdout.writeLine(text)
  quit(1)

#-- Elementos encontrados y no encontrados
proc foundText*(path, number: string): string {.inline.} =
  return "  * $1 ($2 exports)" % [path, number]

proc noFoundText*(path: string): string {.inline.} =
  return "  $2* $1 (No elements found)$3" % [path, fgx(graydark), nostyle]

#-- Crear un mensaje de loading
proc formatProgress(progress: float): string {.inline.} =
  return &"{progress:.2f}%"

proc loading*(total, num: int) =
  stdout.write("\r  " & formatProgress(num * 100 / total))
  stdout.flushFile()
