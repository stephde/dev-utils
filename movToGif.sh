#!/bin/bash

# convert origin mov file to target gif, so that it can be easily used in pull request overviews

ORIGIN=$1
TARGET=$2

ffmpeg -i $ORIGIN -s 600x400 -pix_fmt rgb24 -r 15 -f gif - | gifsicle --optimize=3 --delay=5 > $TARGET
