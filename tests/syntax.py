#!/usr/bin/env python

import argparse
import subprocess
from pathlib import Path
from os import chdir, environ

### config

# for building the Docker image
dockerfile_path = 'docker/syntest.dockerfile'
image_tag = 'syntest'
# environment outside of the Docker container
local_tests_path = '"$PWD/syntax"'
local_syntaxes_path = '"$PWD/../syntaxes"'
# environment within the Docker container
mounted_tests_path = '/tests/syntax'
mounted_syntaxes_path = '/syntaxes/source'
_vendor_syntaxes_path = '/syntaxes/vendor' # created by the Dockerfile
syntaxes_path = '/syntaxes'

### cli

parser = argparse.ArgumentParser(
    description='Run syntax tests in tests/syntax/.'
)
parser.add_argument(
    'test_path', type=str, nargs='?',
    help='path to a particular syntax test in tests/syntax/, \
          relative from the root directory of the project'
)
parser.add_argument('-d', '--debug', action='store_true', help="like syntest's --debug")
parser.add_argument('-s', '--summary', action='store_true', help="like syntest's --summary")

script_args = parser.parse_args()

### utils

prefix = "syntax.py: "

def info(msg):
    blue_msg = "\033[34m" + prefix + msg + "\033[00m"
    print(blue_msg)

def error(msg):
    print(color_red(prefix + msg))

def color_red(msg):
    return f"\033[31m{msg}\033[00m"

def color_green(msg):
    return f"\033[32m{msg}\033[00m"

### environment

source_path = Path(__file__).resolve()
source_dir = source_path.parent # tests/
chdir(source_dir)

if environ.get('CI'):
    # In GitHub Actions, syntest is built in a previous step yet Docker can't reuse its cache.
    # So we trust that the image will be available, we don't need to build it.
    pass
else:
    info("Building syntest Docker image ...")
    build_command = f"docker build --quiet --tag {image_tag} - < {dockerfile_path}"
    build_return = subprocess.call(build_command, shell=True)
    if build_return != 0:
        error(f"Docker image build failed (exit code {build_return}), fix that and try again.")
        exit(1)

### arrange arguments

volumes = f'-v={local_tests_path}:{mounted_tests_path} -v={local_syntaxes_path}:{mounted_syntaxes_path}'
tests_root_path = script_args.test_path or mounted_tests_path
args = f"{tests_root_path} {syntaxes_path}"
if script_args.debug:
    args += " --debug"
if script_args.summary:
    args += " --summary"

### run

info("Running syntax tests ...")
syntest_command = f"docker run --rm {volumes} {image_tag} {args}"
syntest_process = subprocess.run(syntest_command, shell=True, capture_output=True, text=True)
syntest_output = syntest_process.stdout

### process output

noise_line = "The test file references syntax definition file: cmd-help.sublime-syntax"
signal_lines = [line for line in syntest_output.splitlines() if line != noise_line]
signal_lines = signal_lines[1:] # drop "loading syntax definitions from /syntaxes"

last_line = signal_lines[-1]
success = last_line == "exiting with code 0"
if success:
    signal_lines[-1] = color_green(last_line)
else:
    signal_lines[-1] = color_red(last_line)

print("\n".join(signal_lines))
exit(0 if success else 1)
