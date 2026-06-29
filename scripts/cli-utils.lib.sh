# usage: $ source scripts/cli-utils.lib.sh
# shellcheck shell=bash

# prefix for regression tests diff/show commands
reg_git=(
    env
    # force git's default pager, so e.g. delta doesn't strip ANSI colors
    GIT_PAGER="LESS=R less"
    git
    # override the diff.ansi driver in gitconfig_delta
    -c diff.ansi.binary=false
)

# regression tests diff
# to focus on a particular test, do e.g.:
#   reg -- tests/highlighted/bat-short.0.22.1.txt`
# to exclude e.g. THEME-italics, do:
#   reg -- ":^*-italics*"
function reg {
    if [[ "$*" != *"-- "* ]]; then
        "${reg_git[@]}" diff "$@" -- tests/{highlighted,theme}
    else
        # the function args include a path filter
        "${reg_git[@]}" diff "$@"
    fi
}

function regs {
    reg --staged "$@"
}

function regmain {
    reg main "$@"
}

# regression tests show
function regshow {
    if [[ "$*" != *"-- "* ]]; then
        "${reg_git[@]}" show "$@" -- tests/{highlighted,theme}
    else
        "${reg_git[@]}" show "$@"
    fi
}

alias git0='GIT_CONFIG=/dev/null git'

# run a syntax test in debug mode
function debug {
    tests/syntax.py "$@" -d | less -R
}

function demo {
    "$@" --help | bat --no-config -pl cmd-help --pager='less -R'
}

function demo_it {
    "$@" --help | bat --no-config -pl cmd-help --pager='less -R' --italic-text=always
}

alias mksyn='scripts/make_syntax_test.sh'

alias try='scripts/try_input.sh'

# This function detects when git-delta is the diff pager, and then configures Git so it
# treats highlighted files as binary, which removes noise from diff and show commands.
#
# Motivation: git-delta strips ANSI color escape sequences from its input and so the diffs
# for highlighted tests show the same default-foreground color for both the minus and the
# plus. That lack of a diff makes them useless noise.
#
# When the pager is Git's default pager (LESS=R less), the color diffs are shown alright,
# so we preserve that behavior.
#
# The function can run each time we source cli-utils because it's idempotent.
function _sync_delta_gitconfig_include {
    local include_file=".gitconfig_delta"
    # relative to .git/, where .git/config (the includer) lives
    local include_path="../$include_file"
    local blue='\033[34m'
    local reset='\033[0m'

    local uses_delta=false
    if git config --get pager.diff 2>/dev/null | grep -q delta \
        || git config --get pager.show 2>/dev/null | grep -q delta; then
        uses_delta=true
    fi

    local already_included=false
    if git config --local --get-all include.path 2>/dev/null | grep -Fxq "$include_path"; then
        already_included=true
    fi

    if [[ "$uses_delta" == true && "$already_included" == false ]]; then
        git config --local --add include.path "$include_path"
        echo -e "${blue}cli-utils: delta detected as pager, added $include_file to local gitconfig${reset}"
    elif [[ "$uses_delta" == false && "$already_included" == true ]]; then
        git config --local --unset --fixed-value include.path "$include_path"
        echo -e "${blue}cli-utils: delta not detected as pager, removed $include_file from local gitconfig${reset}"
    fi
}
_sync_delta_gitconfig_include
unset -f _sync_delta_gitconfig_include
