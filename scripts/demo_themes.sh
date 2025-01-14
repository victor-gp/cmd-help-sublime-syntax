#!/usr/bin/env bash

set -euo pipefail

# change dir to scripts/
cd "$(dirname "${BASH_SOURCE[0]}")"

echo "building docker image ..."
docker build -f ../tests/docker/bat-test.dockerfile -t bat-test .. &> /dev/null
printf '\e[A\e[K' # clear previous line
image_id=$(docker image inspect --format "{{.Id}}" bat-test)
echo "using docker image $image_id"

vol_src="$PWD"/../tests/source/:/tests/source:ro
vol_dest="$PWD"/../examples/themes/txt/:/tests/destination

docker run --rm \
    --user "$(id -u):$(id -g)" \
    -v "$vol_src" -v "$vol_dest" \
    --entrypoint /tests/inner_demo_themes.sh \
    bat-test
