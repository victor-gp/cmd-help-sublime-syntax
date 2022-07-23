#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

for source_path in source/* ; do
    # this dir is only for theme_regression_inner.sh
    [ "$source_path" = source/theme ] && continue

    filename=$(basename "$source_path")
    highlighted_path="highlighted/$filename"
    bat --no-config -fpl cmd-help "$source_path" > "$highlighted_path"
done
