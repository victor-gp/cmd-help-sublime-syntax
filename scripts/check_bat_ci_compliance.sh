#!/usr/bin/env bash

theirs=https://raw.githubusercontent.com/sharkdp/bat/refs/heads/master/tests/syntax-tests/highlighted/cmd-help/test.cmd-help
ours=tests/highlighted/bat-short-0.22.1.txt
theirs_copy=/tmp/bat-regression-test.cmd-help
ours_basename=$(basename $ours)

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 9

# Fetch regression test from `bat`
curl --location --output $theirs_copy $theirs &> /dev/null
curl_exit_status=$?
if [ $curl_exit_status -ne 0 ]; then
    echo "could not fetch the bat regression test, curl failed with code $curl_exit_status."
    exit 1
fi

# check compliance with our regression test in bat CI
if ! diff ../$ours $theirs_copy; then
    cat <<EOF
::warning file=$ours,title=Would fail bat CI::\
The highlight changes to $ours_basename would fail CI in the bat project. For more details, see: \
https://github.com/victor-gp/cmd-help-sublime-syntax/wiki/How-to-manually-bump-cmd%E2%80%90help-version-in-bat%27s-submodules
EOF
    exit 1
else
    echo "ok: $ours matches the version for bat CI"
fi
