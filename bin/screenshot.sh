#!/bin/bash

SCREENSHOTS_DIR=$HOME/shots

if [[ ! -d $SCREENSHOTS_DIR ]]; then
    mkdir $SCREENSHOTS_DIR
fi

mv $(scrot -q 100 -e 'echo $f') $SCREENSHOTS_DIR/
notify-send "Screenshot taken"
