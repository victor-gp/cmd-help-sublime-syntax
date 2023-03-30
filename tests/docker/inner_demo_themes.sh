#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")" # /tests

cmd_prefix="bat --no-config -fpl cmd-help"
src='source/theme/demo.txt'

readarray -t themes <<< "$(bat --list-themes --color=never)"

for theme in "${themes[@]}"; do
    dest="destination/${theme}.txt"
    dest_it="${dest/.txt/-italics.txt}"

    $cmd_prefix --theme="$theme" $src > "$dest"
    $cmd_prefix --theme="$theme" --italic-text=always $src > "$dest_it"

    # remove the italics version if there's no difference
    if diff "$dest_it" "$dest" > /dev/null
    then rm "$dest_it"
    fi
done
