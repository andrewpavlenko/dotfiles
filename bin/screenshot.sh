#!/bin/bash

SCREENSHOTS_DIR=$HOME/screenshots

if [[ ! -d $SCREENSHOTS_DIR ]]; then
    mkdir $SCREENSHOTS_DIR
fi

scrot -q 100 -e 'mv $f ~/screenshots/'
notify-send "Screenshot taken"
