#!/usr/bin/env bash

# call stack: this << bat-test.dockerfile << scripts/demo_themes.sh

set -euo pipefail

# change dir to /tests/ because src & dest volumes are mapped there.
cd /tests

cmd_prefix="bat --no-config -fpl cmd-help"
src='source/theme/demo.txt'

readarray -t themes <<< "$(bat --list-themes --color=never)"

for theme_ in "${themes[@]}"; do
    # strip " (default)" and " (default light)" from theme names, because bat doesn't recognize that. sharkdp/bat#3188
    theme="${theme_% \(default*\)}"

    dest="destination/${theme}.txt"
    dest_it="${dest/.txt/-italics.txt}"

    $cmd_prefix --theme="$theme" $src > "$dest"
    $cmd_prefix --theme="$theme" --italic-text=always $src > "$dest_it"

    # remove the italics version if there's no difference
    if diff "$dest_it" "$dest" > /dev/null
    then rm "$dest_it"
    fi
done
