#!/usr/bin/env bash

set -euo pipefail

# change dir to tests/
cd "$(dirname "${BASH_SOURCE[0]}")"

echo -n "using docker image "
docker build --quiet -f docker/bat-test.dockerfile -t bat-test ..

vol1="$PWD"/source:/tests/source:ro
vol2="$PWD"/theme:/tests/theme

docker run --rm \
    -v "$vol1" -v "$vol2" \
    --entrypoint /tests/inner_theme_regression.sh \
    bat-test

# if we're running locally
if [ -z ${CI+x} ]; then
    # effective difference between staging/HEAD and working dir
    GIT_PAGER='LESS=R less' git diff -- theme/

# when we're running on GitHub Actions
elif ! git diff --exit-code -- theme/ > /dev/null; then
    echo "::error::Generated theme regression tests differ from those checked in." \
        "Please run \`tests/theme_regression.sh\` and add \`tests/theme/\` changes to the commit."
    exit 1
fi
