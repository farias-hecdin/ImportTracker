import pkg/cmdos

#-- Configurar la interfaz de cli
const helpCmd* = CmdosCmd(names: @["-h", "--help"], desc: "Display this help message and exit.")
const parseCmd* = CmdosCmd(
  names: @["parse"],
  desc: "Generate an index file.",
  opts: @[
    (@["-p", "--pattern"], @["export *"], "Define export pattern.", "<pattern>"),
    (@["-d", "--dir"], @["./"], "Specify a directory.", "<path>"),
    (@["-e", "--ext"], @["jsx"], "Specifies the index file extension.", "<filetype>"),
    (@["-r", "--recursive"], @[], "Enable the recursive search.", ""),
    (@["-l", "--log"],  @[], "Enable the display of file export messages.", "")
  ],
)

#-- Generar el mensaje de ayuda para el cli
const cliSetup* = Cmdos(name: "impzy", cmds: @[parseCmd, helpCmd])
const helpMsg* = processHelp(cliSetup)
