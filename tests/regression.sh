#!/usr/bin/env bash

set -eou pipefail

# help.sublime-syntax must be symlinked to ~/.config/bat/syntaxes/
bat cache --build

cd "$(dirname "${BASH_SOURCE[0]}")"

for source_path in source/*
do
    filename=$(basename "$source_path")
    highlighted_path="highlighted/$filename"
    bat --no-config -fpl cmd-help "$source_path" > "$highlighted_path"
done

# have git tell the effective difference between the version of the syntax
# in staging/HEAD and the one in working dir, for all highlighted samples
GIT_PAGER='LESS=R less' git diff --color=never -- highlighted/
