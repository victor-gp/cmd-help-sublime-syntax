#!/usr/bin/env bash

# run a help message (stdin) by bat-test, i.e.: the local version of cmd-help.sublime-syntax

# usage:
#   $ <CMD> --help | scripts/try_input.sh
#   $ scripts/try_input.sh < <HELP_MSG_FILE>
#   $ pbpaste | scripts/try_input.sh

set -euo pipefail

# change dir to scripts/
cd "$(dirname "${BASH_SOURCE[0]}")"

echo "building docker image ..."
docker build -f ../tests/docker/bat-test.dockerfile -t bat-test .. &> /dev/null
printf '\e[A\e[K' # clear previous line
image_id=$(docker image inspect --format "{{.Id}}" bat-test)
echo "using docker image $image_id"

bat_options=(--no-config --plain --language=cmd-help --force-colorization)

cat |
    docker run --rm --interactive --entrypoint=bat bat-test "${bat_options[@]}" |
    less -R
