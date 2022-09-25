#!/bin/bash

# usage: scripts/make_syntax_test.sh tests/source/<file>
# or:    mksyn tests/source/<file>   (if you $ source scripts/env.sh)


set -euo pipefail

# change dir to project root
cd "$(dirname "${BASH_SOURCE[0]}")/.."

if [ $# -ne 1 ] || [ ! -f "$1" ]; then
    >&2 echo "usage: $0 tests/source/<file>"
    exit 2
fi

src_prefix='tests\/source\/'
src_suffix='-[0-9].*\.txt'
dest_prefix='tests\/syntax\/syntax_test_'

src=$1

if [[ "$src" != $src_prefix* ]]; then
    >&2 echo "error: source file '$src' is not in tests/source/"
    exit 2
fi

dest=$(
    sed <<< "$src" \
    -e "s/$src_prefix/$dest_prefix/" \
    -e "s/$src_suffix/.txt/"
)

if [ -f "$dest" ]; then
    >&2 echo "error: syntax test '$dest' already exists."
    exit 1
fi


cat > "$dest" <<EOHeader
# SYNTAX TEST "cmd-help.sublime-syntax"

EOHeader
cat "$src" >> "$dest"

echo "make_syntax_test: created '$dest'"
