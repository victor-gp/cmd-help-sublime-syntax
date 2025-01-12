#!/usr/bin/env bash

set -euo pipefail

# change dir to tests/
cd "$(dirname "${BASH_SOURCE[0]}")"

echo -n "using docker image "
docker build --quiet -f docker/bat-test.dockerfile -t bat-test ..

vol_src="$PWD"/source:/tests/source:ro
vol_dest="$PWD"/highlighted:/tests/highlighted

docker run --rm \
    -v "$vol_src" -v "$vol_dest" \
    --entrypoint /tests/inner_highlight_regression.sh \
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
