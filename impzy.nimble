# Package

version       = "2.4.0"
author        = "Hecdin Farias"
description   = "CLI tool to generate an index file of JavaScript exports."
license       = "MIT"
srcDir        = "src"
bin           = @["impzy"]
skipDirs      = @["tests"]

# Dependencies

requires "nim >= 1.6.0"
requires "https://github.com/khchen/tinyre"
requires "https://github.com/farias-hecdin/Cmdos"
requires "https://github.com/farias-hecdin/HexToAnsi"
