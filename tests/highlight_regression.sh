#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

docker compose -f docker/bat-server.compose.yaml up -d

docker exec bat-server bash /tests/run_highlight_regression.sh

# have git tell the effective difference between the version of the syntax
# in staging/HEAD and the one in working dir, for all highlighted samples
GIT_PAGER='LESS=R less' git diff -- highlighted/
