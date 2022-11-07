#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

echo -n "using docker image "
docker build --quiet -f docker/bat-test.dockerfile -t bat-test ..

vol1="$PWD"/source:/tests/source:ro
vol2="$PWD"/highlighted:/tests/highlighted

docker run --rm \
    -v "$vol1" -v "$vol2" \
    bat-test

# if $CI is unset
if [ -z ${CI+x} ]; then
    # have git tell the effective difference between the version of the syntax
    # in HEAD/staging and the one in working dir, for all highlighted samples
    GIT_PAGER='LESS=R less' git diff -- highlighted/

elif ! git diff --exit-code -- highlighted > /dev/null; then
    echo "::error::Generated highlight regression tests differ from those checked in." \
        "Please run \`tests/highlight_regression.sh\` and add \`tests/highlighted/\` to the commit."
    exit 1
fi
