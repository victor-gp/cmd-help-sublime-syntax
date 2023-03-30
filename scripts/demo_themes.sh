#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

echo -n "using docker image "
docker build --quiet -f ../tests/docker/bat-test.dockerfile -t bat-test ..

vol1="$PWD"/../tests/source/:/tests/source:ro
vol2="$PWD"/../examples/themes/txt/:/tests/destination

docker run --rm \
    -v "$vol1" -v "$vol2" \
    --entrypoint tests/inner_demo_themes.sh \
    bat-test
