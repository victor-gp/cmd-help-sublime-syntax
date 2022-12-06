#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

if [ ! -d ../docs/assets/theme-demo ]; then
    mkdir ../docs/assets/theme-demo
fi

echo -n "using docker image "
docker build --quiet -f ../tests/docker/bat-test.dockerfile -t bat-test ..

vol1="$PWD"/../docs/assets:/tests/assets

docker run --rm \
    -v "$vol1" \
    --entrypoint tests/inner_demo_themes.sh \
    bat-test
