#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

docker compose -f docker/bat-server.compose.yaml up -d

docker exec bat-server bash /tests/run_theme_regression.sh

# effective difference between HEAD/staging and working dir
GIT_PAGER='LESS=R less' git diff -- theme/
