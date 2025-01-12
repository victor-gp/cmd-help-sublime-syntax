#!/usr/bin/env bash

set -euo pipefail

# change dir to tests/
cd "$(dirname "${BASH_SOURCE[0]}")"

echo -n "using docker image "
docker build --quiet -f docker/bat-test.dockerfile -t bat-test ..

vol1="$PWD"/source:/tests/source:ro
vol2="$PWD"/highlighted:/tests/highlighted

docker run --rm \
    -v "$vol1" -v "$vol2" \
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
fi
