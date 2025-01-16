#!/usr/bin/env bash

# call stack: this << bat-test.dockerfile << tests/highlight_regression.sh

set -euo pipefail

# change dir to /tests/. src & dest volumes are mapped here.
cd "$(dirname "${BASH_SOURCE[0]}")"

for source_path in source/* ; do
    # this dir is only for theme tests and demos
    [ "$source_path" = source/theme ] && continue

    filename=$(basename "$source_path")
    highlighted_path="highlighted/$filename"
    bat --no-config -fpl cmd-help "$source_path" > "$highlighted_path"
done
