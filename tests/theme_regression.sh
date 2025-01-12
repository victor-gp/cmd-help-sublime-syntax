#!/usr/bin/env bash

set -euo pipefail

# change dir to tests/
cd "$(dirname "${BASH_SOURCE[0]}")"

echo -n "using docker image "
docker build --quiet -f docker/bat-test.dockerfile -t bat-test ..

vol_src="$PWD"/source:/tests/source:ro
vol_dest="$PWD"/theme:/tests/theme

docker run --rm \
    -v "$vol_src" -v "$vol_dest" \
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
