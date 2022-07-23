#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

echo -n "using docker image "
docker build --quiet -f docker/bat-test.dockerfile -t bat-test ..

vol1="$PWD"/source:/tests/source:ro
vol2="$PWD"/theme:/tests/theme

docker run --rm \
    -v "$vol1" -v "$vol2" \
    --entrypoint /tests/run_theme_regression.sh \
    bat-test

# effective difference between HEAD/staging and working dir
GIT_PAGER='LESS=R less' git diff -- theme/
