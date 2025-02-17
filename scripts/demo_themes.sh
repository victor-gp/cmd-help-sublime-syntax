#!/usr/bin/env bash

# usage:
# - execute this to get the bat-highlighted txt files for each theme (w/o italics)
# - then go over each file and take screenshots. I dunno how to automate this. *sobs*

set -euo pipefail

dest_dir=examples/theme

# change dir to scripts/
cd "$(dirname "${BASH_SOURCE[0]}")"

echo "building docker image ..."
docker build -f ../tests/docker/bat-test.dockerfile -t bat-test .. &> /dev/null
printf '\e[A\e[K' # clear previous line
image_id=$(docker image inspect --format "{{.Id}}" bat-test)
echo "using docker image $image_id"

vol_src="$PWD"/../tests/source/:/tests/source:ro
vol_dest="$PWD"/../$dest_dir/:/tests/destination
mkdir -p ../$dest_dir

docker run --rm \
    --user "$(id -u):$(id -g)" \
    -v "$vol_src" -v "$vol_dest" \
    --entrypoint /tests/entrypoints/demo_themes.sh \
    bat-test
