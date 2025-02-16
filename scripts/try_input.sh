#!/usr/bin/env bash

# run a help message (stdin) by bat-test, i.e.: the local version of cmd-help.sublime-syntax

# usage:
#   $ <CMD> --help | scripts/try_input.sh
#   $ scripts/try_input.sh < <HELP_MSG_FILE>
#   $ pbpaste | scripts/try_input.sh

bat_options=(--no-config --plain --language=cmd-help --force-colorization)

cat |
    docker run --interactive --entrypoint=bat bat-test "${bat_options[@]}" |
    less -R
