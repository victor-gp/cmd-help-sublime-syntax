#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

bat cache --build --source .. > /dev/null

for source_path in source/*
do
    filename=$(basename "$source_path")
    highlighted_path="highlighted/$filename"
    bat --no-config -fpl cmd-help "$source_path" > "$highlighted_path"
done

# restore user configuration
bat cache --build > /dev/null

# have git tell the effective difference between the version of the syntax
# in staging/HEAD and the one in working dir, for all highlighted samples
GIT_PAGER='LESS=R less' git diff -- highlighted/
