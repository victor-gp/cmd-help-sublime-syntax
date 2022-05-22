#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

bat cache --build --source .. > /dev/null

highlight() {
    bat --no-config -fpl cmd-help theme-source/synthetic.txt --theme "$1" > "$2"
}

# this is a hell of a hack :see_no_evil:
IFS=$'\n'
for theme in $(bat --list-themes --color=never)
do
    unset IFS # then bash uses default IFS
    highlight "$theme" "theme/${theme}.txt"
done

# restore user configuration
bat cache --build > /dev/null

# have git tell the effective difference between the version of the syntax
# in staging/HEAD and the one in working dir, for all themes
GIT_PAGER='LESS=R less' git diff -- theme/
