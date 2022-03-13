#!/bin/bash

# place these somewhere in your bashrc/zshrc/*rc

alias bathelp="bat -p --language=cmd-help"

help() (
    "$@" --help | bathelp
)
