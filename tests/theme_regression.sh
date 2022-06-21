#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

bat cache --build --source .. > /dev/null

readarray -t themes <<< "$(bat --list-themes --color=never)"
cmd_prefix="bat --no-config -fpl cmd-help theme-source/synthetic.txt"

for theme in "${themes[@]}"; do
    $cmd_prefix --theme="$theme" > "theme/${theme}.txt"
    $cmd_prefix --theme="$theme" --italic-text=always > "theme/${theme}-italics.txt"
    # remove the italics version if there's no difference
    if diff "theme/${theme}.txt" "theme/${theme}-italics.txt" > /dev/null
    then
        rm "theme/${theme}-italics.txt"
    fi
done

# restore user configuration
bat cache --build > /dev/null

# effective difference between HEAD/staging and working dir
GIT_PAGER='LESS=R less' git diff -- theme/
