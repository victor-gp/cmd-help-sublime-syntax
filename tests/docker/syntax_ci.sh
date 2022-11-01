#!/usr/bin/env bash

image_tag='syntest:latest'
tests_dir='/tests/syntax'
syntaxes_path='/syntaxes'

docker run \
    -v="$PWD/tests/syntax":$tests_dir \
    -v="$PWD/syntaxes":$syntaxes_path \
    $image_tag
