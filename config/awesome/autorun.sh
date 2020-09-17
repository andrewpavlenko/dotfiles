#!/usr/bin/env bash

function run {
  if ! pgrep -f $1 ;
  then
    $@&
  fi
}

xrdb "$HOME/.Xresources"
run compton
run redshift
