#!/usr/bin/env bash

set -euo pipefail

# change dir to tests/
cd "$(dirname "${BASH_SOURCE[0]}")"

echo "building docker image ..."
docker build -f docker/bat-test.dockerfile -t bat-test .. &> /dev/null
printf '\e[A\e[K' # clear previous line
image_id=$(docker image inspect --format "{{.Id}}" bat-test)
echo "using docker image $image_id"

vol_src="$PWD"/source:/tests/source:ro
vol_dest="$PWD"/highlighted:/tests/highlighted

docker run --rm \
    --user "$(id -u):$(id -g)" \
    -v "$vol_src" -v "$vol_dest" \
    --entrypoint /tests/entrypoints/highlight_regression.sh \
    bat-test

# if we're running locally
if [ -z ${CI+x} ]; then
    # effective difference between staging/HEAD and working dir
    GIT_PAGER='LESS=R less' git diff -- highlighted/

# when we're running on GitHub Actions
elif ! git diff --exit-code -- highlighted/ > /dev/null; then
    echo "::error::Generated highlight regression tests differ from those checked in." \
        "Please run \`tests/highlight_regression.sh\` and add \`tests/highlighted/\` changes to the commit."
    exit 1

else
    echo "ok: highlight regression tests are consistent with the syntax"
fi
