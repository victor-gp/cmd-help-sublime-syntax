#!/usr/bin/env bash

set -euo pipefail

if [ -v WITHIN_BAT_SERVER ]; then
    cd "$(dirname "${BASH_SOURCE[0]}")"

    bat cache --build --source .. > /dev/null

    for source_path in source/* ; do
        # skip it it's source/theme/
        [ -d  "$source_path" ] && continue

        filename=$(basename "$source_path")
        highlighted_path="highlighted/$filename"
        bat --no-config -fpl cmd-help "$source_path" > "$highlighted_path"
    done
else
    cd "$(dirname "${BASH_SOURCE[0]}")"

    docker compose -f bat-server.compose.yaml up -d
    docker exec bat-server bash /tests/highlight_regression.sh

    # have git tell the effective difference between the version of the syntax
    # in staging/HEAD and the one in working dir, for all highlighted samples
    GIT_PAGER='LESS=R less' git diff -- highlighted/
fi
