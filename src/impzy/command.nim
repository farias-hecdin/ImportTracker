import pkg/[cmdos]

#-- Crear la interfaz de cli

const help* = CmdosCmd(
  names: @["-h", "help"],
  desc: "Display this help message and exit."
)

const version* = CmdosCmd(
  names: @["-v", "--version"],
  desc: "Displays the version number and exit."
)

const parse* = CmdosCmd(
  names: @["parse"],
  desc: "Generate an index file.",
  args: @[
    CmdosArg(
      names: @["-p", "--pattern"], inputs: @["export *"],
      desc: "Define export pattern (e.g. 'export *' or 'export default function').",
      label: "<pattern>"
    ),
    CmdosArg(
      names: @["-d", "--dir"], inputs: @["./"],
      desc: "Specify a directory (default: './').",
      label: "<path>"
    ),
    CmdosArg(
      names: @["-e", "--ext"], inputs: @["jsx"],
      desc: "Specifies the index file extension (default: .jsx).",
      label: "<filetype>"
    ),
    CmdosArg(
      names: @["-r", "--recursive"], inputs: @["on"],
      desc: "Enable the recursive search (default: on).",
      label: "<on/off>"
    ),
    CmdosArg(
      names: @["-s", "--show"], inputs: @["on"],
      desc: "enable the display of file export messages (default: on).",
      label: "<on/off>"
    ),
  ]
)

const cli* = Cmdos(
  name: "impzy",
  version: "2.3.0",
  cmds: @[parse, version, help]
)

#-- Procesar el mensaje de ayuda para el cli
const helpMsg* = processHelp(cli)

