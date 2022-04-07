#!/bin/bash

# place these somewhere in your .bashrc/.zshrc/*rc

alias bathelp='bat --plain --language=cmd-help'

help() {
    "$@" --help 2>&1 | bathelp
}
