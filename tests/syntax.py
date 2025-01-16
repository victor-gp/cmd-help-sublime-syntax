#!/usr/bin/env python

import argparse
import subprocess
from pathlib import Path
from os import chdir
import urllib.request

### config

dockerfile_path = 'docker/syntest.dockerfile'
image_tag = 'syntest'
tests_dir = '/tests/syntax'
syntaxes_path = '/syntaxes'
volumes = f'-v="$PWD/syntax":{tests_dir} -v="$PWD/../syntaxes":{syntaxes_path}'

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

info("Building syntest Docker image ...")
build_command = f"docker build --quiet --tag {image_tag} - < {dockerfile_path}"
build_return = subprocess.call(build_command, shell=True)
if build_return != 0:
    error(f"Docker image build failed (exit code {build_return}), fix that and try again.")
    exit(1)

man_syntax_path = Path('../syntaxes/Manpage.sublime-syntax')
if not man_syntax_path.is_file():
    info("Manpage syntax is missing, downloading it...")
    man_syntax = urllib.request.urlretrieve(
        'https://raw.githubusercontent.com/sharkdp/bat/master/assets/syntaxes/02_Extra/Manpage.sublime-syntax',
        '../syntaxes/Manpage.sublime-syntax'
    )

### arrange arguments

args = f"{script_args.test_path or tests_dir} {syntaxes_path}"
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

if not success:
    exit(1)
