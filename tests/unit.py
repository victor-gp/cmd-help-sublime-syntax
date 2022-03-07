#!/usr/bin/env python

import argparse
import subprocess
from pathlib import Path
from os import chdir

### config

dockerfile_path = 'syntest.dockerfile'
image_tag = 'syntest'
volume = '-v="$PWD/syntax":/tests/syntax'

### cli

parser = argparse.ArgumentParser(
    description='Run syntax tests in tests/syntax/.'
)
parser.add_argument(
    'path', type=str, nargs='?',
    help='path to a particular syntax test in tests/syntax/, \
          relative from the root directory of the project'
)
parser.add_argument('-d', '--debug', action='store_true')
parser.add_argument('-s', '--summary', action='store_true')

script_args = parser.parse_args()

### environment

source_path = Path(__file__).resolve()
source_dir = source_path.parent # test/
chdir(source_dir)

ret = subprocess.call(
    f"docker inspect {image_tag}",
    shell=True,
    stdout=subprocess.DEVNULL,
    stderr=subprocess.DEVNULL
)
if ret != 0: # image doesn't exist
    subprocess.call(
        f"docker build -f {dockerfile_path} -t {image_tag} .",
        shell=True
    )

subprocess.call(
    "cp ../cmd-help.sublime-syntax syntax/under-test",
    shell=True
)

### arrange arguments

default_tests_path = '/tests/syntax'
default_syntaxes_path = '/tests/syntax/under-test'

args = ""
if script_args.path:
    args = f"{script_args.path} {default_syntaxes_path}"
if script_args.debug:
    if not args:
        args = f"{default_tests_path} {default_syntaxes_path}"
    args += " --debug"
if script_args.summary:
    if not args:
        args = f"{default_tests_path} {default_syntaxes_path}"
    args += " --summary"

### run

subprocess.call(
    f"docker run --rm {volume} {image_tag} {args}",
    shell=True
)
