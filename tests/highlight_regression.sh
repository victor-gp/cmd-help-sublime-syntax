#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

docker build --quiet -f docker/bat-test.dockerfile -t bat-test ..

vol1="$PWD"/source:/tests/source:ro
vol2="$PWD"/highlighted:/tests/highlighted
docker run --rm \
    -v "$vol1" -v "$vol2" \
    bat-test

# have git tell the effective difference between the version of the syntax
# in staging/HEAD and the one in working dir, for all highlighted samples
GIT_PAGER='LESS=R less' git diff -- highlighted/
