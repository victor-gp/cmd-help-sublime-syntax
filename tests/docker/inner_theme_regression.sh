#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

cmd_prefix="bat --no-config -fpl cmd-help"
brief_src="source/theme/brief.txt"
synthetic_src="source/theme/synthetic.txt"

readarray -t themes <<< "$(bat --list-themes --color=never)"

for theme in "${themes[@]}"; do
    $cmd_prefix --theme="$theme" $brief_src > "theme/brief-${theme}.txt"

    $cmd_prefix --theme="$theme" \
        $synthetic_src > "theme/synthetic-${theme}.txt"
    $cmd_prefix --theme="$theme" --italic-text=always \
        $synthetic_src > "theme/synthetic-${theme}-italics.txt"

    # remove the italics version if there's no difference
    if diff "theme/synthetic-${theme}-italics.txt" "theme/synthetic-${theme}.txt" > /dev/null
    then rm "theme/synthetic-${theme}-italics.txt"
    fi
done
