#!/bin/bash

SCREENSHOTS_DIR=$HOME/shots

if [[ ! -d $SCREENSHOTS_DIR ]]; then
    mkdir $SCREENSHOTS_DIR
fi

shot=$(scrot -q 100 -e 'echo $f')
mv $shot $SCREENSHOTS_DIR/
# notify-send "Screenshot taken"
awesome-client "awesome.emit_signal(\"awesome::screenshot\", \"$shot\", \"$SCREENSHOTS_DIR/$shot\")"
