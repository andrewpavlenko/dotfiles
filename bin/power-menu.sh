#!/bin/bash

# small power menu using rofi, i3, systemd and pm-utils
# (last 3 dependencies are adjustable below)
# tostiheld, 2016

poweroff_command="systemctl poweroff"
reboot_command="systemctl reboot"
hibernate_command="systemctl hibernate"
suspend_command="systemctl suspend"

# you can customise the rofi command all you want ...
rofi_command="rofi -lines 4"

options=$'poweroff\nreboot\nhibernate\nsuspend' 

# ... because the essential options (-dmenu and -p) are added here
eval \$"$(echo "$options" | $rofi_command -dmenu -p "power")_command"
