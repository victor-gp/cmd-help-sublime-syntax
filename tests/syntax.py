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
    print("\033[34m" + "Docker image not available, building syntest from source..." + "\033[00m")
    subprocess.call(
        f"docker build -t {image_tag} - < {dockerfile_path}",
        shell=True
    )
    print("\033[34m" + f"Docker image successfully built, tagged '{image_tag}'." + "\033[00m")

man_syntax_path = Path('../syntaxes/Manpage.sublime-syntax')
if not man_syntax_path.is_file():
    print("\033[34m" + "Manpage syntax is missing, downloading it..." + "\033[00m")
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
success = last_line == "exiting with code 0"

if success: # colorize last line in green
    signal_lines[-1] = f"\033[32m{last_line}\033[00m"
else: # colorize last line in red
    signal_lines[-1] = f"\033[31m{last_line}\033[00m"
print("\n".join(signal_lines))

if not success:
    exit(1)
