#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

docker build --quiet -f docker/bat-test.dockerfile -t bat-test ..

volume="$PWD"/theme:/tests/theme
docker run -v "$volume" \
    --entrypoint /tests/run_theme_regression.sh \
    bat-test

# effective difference between HEAD/staging and working dir
GIT_PAGER='LESS=R less' git diff -- theme/
