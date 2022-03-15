#!/usr/bin/env python

import argparse
import subprocess
from pathlib import Path
from os import chdir

### config

dockerfile_path = 'syntest.dockerfile'
image_tag = 'syntest'
tests_path = '/tests/syntax'
syntaxes_path = '/syntaxes'
volumes = f'-v="$PWD/syntax":{tests_path} -v="$PWD/../syntaxes":{syntaxes_path}'

### cli

parser = argparse.ArgumentParser(
    description='Run syntax tests in tests/syntax/.'
)
parser.add_argument(
    'test_path', type=str, nargs='?',
    help='path to a particular syntax test in tests/syntax/, \
          relative from the root directory of the project'
)
parser.add_argument('-d', '--debug', action='store_true')
parser.add_argument('-s', '--summary', action='store_true')

script_args = parser.parse_args()

### environment

source_path = Path(__file__).resolve()
source_dir = source_path.parent # tests/
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

### arrange arguments

args = ""
if script_args.test_path:
    args = f"{script_args.test_path} {syntaxes_path}"
else:
    args = f"{tests_path} {syntaxes_path}"

if script_args.debug:
    args += " --debug"
if script_args.summary:
    args += " --summary"

### run

completed_process = subprocess.run(
    f"docker run --rm {volumes} {image_tag} {args}",
    shell=True,
    capture_output=True,
    text=True,
)
output = completed_process.stdout

### process output

noise_line = "The test file references syntax definition file: cmd-help.sublime-syntax"
signal_lines = [line for line in output.splitlines() if line != noise_line]

last_line = signal_lines[-1]
if last_line == "exiting with code 0":
    # colorize last line in green
    signal_lines[-1] = f"\033[32m{last_line}\033[00m"
else:
    # colorize last line in red
    signal_lines[-1] = f"\033[31m{last_line}\033[00m"

print("\n".join(signal_lines))
