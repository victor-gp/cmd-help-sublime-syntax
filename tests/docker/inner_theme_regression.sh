#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

cmd_prefix="bat --no-config -fpl cmd-help"
brief_src="source/theme/brief.txt"
synthetic_src="source/theme/synthetic.txt"

readarray -t themes <<< "$(bat --list-themes --color=never)"

for theme_ in "${themes[@]}"; do
    # strip " (default)" and " (default light)" from theme name, because bat doesn't recognize that
    theme="${theme_% \(default*\)}"

    $cmd_prefix --theme="$theme" $brief_src > "theme/brief-${theme}.txt"

    synthetic_dest="theme/synthetic-${theme}.txt"
    synthetic_it_dest="theme/synthetic-${theme}-italics.txt"

    $cmd_prefix --theme="$theme" $synthetic_src > "$synthetic_dest"
    $cmd_prefix --theme="$theme" --italic-text=always $synthetic_src > "$synthetic_it_dest"

    # remove the italics version if there's no difference
    if diff "$synthetic_it_dest" "$synthetic_dest" > /dev/null
    then rm "$synthetic_it_dest"
    fi
done
