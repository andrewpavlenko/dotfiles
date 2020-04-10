#!/usr/bin/env bash

function run {
  if ! pgrep -f $1 ;
  then
    $@&
  fi
}

run compton
run redshift

# Run GUI authentication manager. This command specific for package name on your distro
run /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1

# Keyboard layout
setxkbmap -layout "us,ru,ua" -option "grp:alt_shift_toggle"
