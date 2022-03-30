#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

bat cache --build --source .. > /dev/null

highlight() {
    bat --no-config -fpl cmd-help "$2" --theme "$1" > "$3"
}

IFS=$'\n'
for theme in $(bat --list-themes --color=never)
do
    unset IFS # then bash uses default IFS

    source_path=source/bat-short-0.18.2.txt
    highlight "$theme" "$source_path" "theme/${theme}-1.txt"
    source_path=source/vim-8.1.txt
    highlight "$theme" "$source_path" "theme/${theme}-2.txt"
    source_path=source/python-3.10.0.txt
    highlight "$theme" "$source_path" "theme/${theme}-3.txt"
done

# restore user configuration
bat cache --build > /dev/null

# have git tell the effective difference between the version of the syntax
# in staging/HEAD and the one in working dir, for all themes
GIT_PAGER='LESS=R less' git diff -- theme/
