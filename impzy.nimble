# Package

version       = "2.3.0"
author        = "Farias Hecdin"
description   = "CLI tool to generate an index file of JavaScript exports."
license       = "MIT"
srcDir        = "src"
skipDirs      = @["tests"]
bin           = @["impzy"]

# Dependencies

requires "nim >= 1.6.0"
requires "https://github.com/JessaTehCrow/NimColor"
requires "https://github.com/farias-hecdin/Cmdos"
requires "https://github.com/khchen/tinyre"
