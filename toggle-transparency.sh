#!/bin/bash

# Get the active window address
active_window=$(hyprctl activewindow -j | jq -r '.address')

if [ -z "$active_window" ] || [ "$active_window" = "null" ]; then
    exit 0
fi

# State file to track transparent windows
state_file="/tmp/hypr-transparent-windows"
touch "$state_file"

# Check if window is currently in transparent state
if grep -q "$active_window" "$state_file"; then
    # Window is transparent, make it opaque and enable blur
    hyprctl dispatch setprop address:$active_window alpha 1
    hyprctl dispatch setprop address:$active_window alphainactive 1
    hyprctl dispatch setprop address:$active_window noblur 0
    sed -i "\|$active_window|d" "$state_file"
else
    # Window is opaque, make it transparent and disable blur
    hyprctl dispatch setprop address:$active_window alpha 0.4
    hyprctl dispatch setprop address:$active_window alphainactive 0.4
    hyprctl dispatch setprop address:$active_window noblur 1
    echo "$active_window" >> "$state_file"
fi
