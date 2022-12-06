#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

cmd_prefix="bat --no-config -fpl cmd-help"
demo_src="assets/theme-demo.txt"

readarray -t themes <<< "$(bat --list-themes --color=never)"

for theme in "${themes[@]}"; do
    dest_name="assets/theme-demo/${theme}.txt"
    dest_name_it="${dest_name/.txt/-italics.txt}"

    $cmd_prefix --theme="$theme" $demo_src > "$dest_name"
    $cmd_prefix --theme="$theme" --italic-text=always $demo_src > "$dest_name_it"

    # remove the italics version if there's no difference
    if diff "$dest_name_it" "$dest_name" > /dev/null
    then rm "$dest_name_it"
    fi
done
