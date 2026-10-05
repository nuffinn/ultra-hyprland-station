#!/bin/bash

# Toggle the kitty background between opaque and translucent. Hyprland's blur
# only shows through transparent pixels, so when kitty draws just its
# background at reduced alpha the compositor blurs what is behind it while the
# terminal text stays fully opaque.

blurred=0.7

win=$(hyprctl activewindow -j)
class=$(jq -r '.class' <<<"$win")
pid=$(jq -r '.pid' <<<"$win")

if [[ "$class" != kitty* ]]; then
    notify-send -t 1500 -u low -h string:x-canonical-private-synchronous:kittyblur "Kitty blur" "Active window is not kitty"
    exit 0
fi

socket="unix:/tmp/kitty-$pid"

if ! info=$(kitten @ --to "$socket" ls 2>/dev/null); then
    notify-send -t 1500 -u low -h string:x-canonical-private-synchronous:kittyblur "Kitty blur" "No remote control socket, restart kitty"
    exit 1
fi

current=$(jq -r '.[0].background_opacity' <<<"$info")

if awk "BEGIN{exit !($current < 0.95)}"; then
    kitten @ --to "$socket" set-background-opacity --all 1.0
    notify-send -t 1500 -u low -h string:x-canonical-private-synchronous:kittyblur "Kitty blur" "Off"
else
    kitten @ --to "$socket" set-background-opacity --all "$blurred"
    notify-send -t 1500 -u low -h string:x-canonical-private-synchronous:kittyblur "Kitty blur" "On"
fi
