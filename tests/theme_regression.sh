#!/usr/bin/env bash

set -euo pipefail

# cmd-help.sublime-syntax must be symlinked to ~/.config/bat/syntaxes/
bat cache --build

cd "$(dirname "${BASH_SOURCE[0]}")"

IFS=$'\n'
for theme in $(bat --list-themes --color=never)
do
    unset IFS # then bash uses default IFS

    # skip my custom theme
    [[ "$theme" = custom16 ]] && continue

    source_path=source/bat-short-0.18.2.txt
    highlighted_path="theme/$theme.txt"
    bat --no-config -fpl cmd-help "$source_path" --theme "$theme" > "$highlighted_path"
done

# have git tell the effective difference between the version of the syntax
# in staging/HEAD and the one in working dir, for all themes
GIT_PAGER='LESS=R less' git diff -- theme/
