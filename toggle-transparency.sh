#!/bin/bash

# Toggle the active window between opaque and 40% transparent (blur off while transparent).

# Get the active window address
active_window=$(hyprctl activewindow -j | jq -r '.address')

if [ -z "$active_window" ] || [ "$active_window" = "null" ]; then
    exit 0
fi

# Lua config manager (hyprland.lua): hyprctl dispatch takes a Lua dispatcher expression.
# Legacy hyprlang manager (hyprland.conf): fall back to the old setprop syntax.
if hyprctl eval 'return true' 2>&1 | grep -q 'only supported with the lua'; then
    set_opacity() { hyprctl dispatch setprop "address:$active_window" alpha "$1"; hyprctl dispatch setprop "address:$active_window" alphainactive "$1"; }
    set_noblur()  { hyprctl dispatch setprop "address:$active_window" noblur "$1"; }
else
    set_opacity() { hyprctl dispatch "hl.dsp.window.set_prop({ window = \"address:$active_window\", prop = \"opacity\", value = \"$1 $1\" })"; }
    set_noblur()  { hyprctl dispatch "hl.dsp.window.set_prop({ window = \"address:$active_window\", prop = \"no_blur\", value = \"$1\" })"; }
fi

# State file to track transparent windows
state_file="/tmp/hypr-transparent-windows"
touch "$state_file"

# Check if window is currently in transparent state
if grep -q "$active_window" "$state_file"; then
    # Window is transparent, make it opaque and enable blur
    set_opacity 1
    set_noblur 0
    sed -i "\|$active_window|d" "$state_file"
else
    # Window is opaque, make it transparent and disable blur
    set_opacity 0.4
    set_noblur 1
    echo "$active_window" >> "$state_file"
fi
