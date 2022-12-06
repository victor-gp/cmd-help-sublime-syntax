#!/bin/bash

function gdiff {
    GIT_PAGER="LESS=R less" git diff "$@" -- tests/{highlighted,theme}
}
function gdiffs {
    gdiff --staged "$@"
}
# to exclude e.g. THEME-italics, do:
#   gdiff -- ":^*-italics*"

function gshow {
    GIT_PAGER="LESS=R less" git show "$@" -- tests/{highlighted,theme}
}

alias git0='GIT_CONFIG=/dev/null git'

debug() {
    tests/syntax.py "$@" -d | less -R
}

demo() {
    "$@" --help | bat --no-config -pl cmd-help --pager='less -R'
}

demo_it() {
    "$@" --help | bat --no-config -pl cmd-help --pager='less -R' --italic-text=always
}

alias mksyn='scripts/make_syntax_test.sh'
