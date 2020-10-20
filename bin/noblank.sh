#!/bin/sh
# Disable screen blanking
xset s noblank
xset s off
xset -dpms
tput setaf 3
echo "Screen blanking off."
tput sgr 0
