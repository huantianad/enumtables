# Package

version       = "0.1.0"
author        = "huantian"
description   = "Minimal table-like wrapper for enum-indexed arrays."
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 1.6.0"


# Tasks

task test, "Run unit tests with balls.":
    exec "balls"
