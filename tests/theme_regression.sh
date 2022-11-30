#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

echo -n "using docker image "
docker build --quiet -f docker/bat-test.dockerfile -t bat-test ..

vol1="$PWD"/source:/tests/source:ro
vol2="$PWD"/theme:/tests/theme

docker run --rm \
    -v "$vol1" -v "$vol2" \
    --entrypoint /tests/inner_theme_regression.sh \
    bat-test

# if $CI is unset
if [ -z ${CI+x} ]; then
    # effective difference between HEAD/staging and working dir
    GIT_PAGER='LESS=R less' git diff -- theme/

elif ! git diff --exit-code -- theme > /dev/null; then
    echo "::error::Generated theme regression tests differ from those checked in." \
        "Please run \`tests/theme_regression.sh\` and add \`tests/theme/\` to the commit."
    exit 1
fi
