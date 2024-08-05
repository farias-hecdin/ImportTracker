# Package

version       = "2.2.2"
author        = "Farias Hecdin"
description   = "CLI tool to generate an index file of JavaScript exports."
license       = "MIT"
srcDir        = "src"
skipDirs      = @["tests"]
bin           = @["impzy"]

# Dependencies

requires "nim >= 1.6.0"
requires "NimColor >= 0.1.6"
requires "Cmdos >= 2.0.0"
requires "tinyre >= 1.5.0"
