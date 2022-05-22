#!/usr/bin/env bash

#nice: add tests for --italic-text=always, removing duplicates
#      and replace the IFS hack while I'm at it

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

bat cache --build --source .. > /dev/null

cmd_prefix="bat --no-config -fpl cmd-help theme-source/synthetic.txt"

# this is a hell of a hack :see_no_evil:
IFS=$'\n'
for theme in $(bat --list-themes --color=never)
do
    unset IFS # then bash uses default IFS
    $cmd_prefix --theme="$theme" > "theme/${theme}.txt"
done

# restore user configuration
bat cache --build > /dev/null

# effective difference between HEAD/staging and working dir
GIT_PAGER='LESS=R less' git diff -- theme/
