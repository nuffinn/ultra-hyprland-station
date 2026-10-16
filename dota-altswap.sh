#!/usr/bin/env bash
# Drop the altwin:swap_lalt_lwin xkb option while a Dota 2 window is focused,
# so the physical Alt key is a real Alt in-game (ping wheel, alt-click pings).
# Restores the normal layout as soon as focus leaves Dota.
# Started from hyprland.lua via the hyprland.start event.

NORMAL="ctrl:swapcaps,altwin:swap_lalt_lwin"   # must match input.kb_options in hyprland.lua
GAMING="ctrl:swapcaps"
MATCH='^dota2$'                                 # window class, case-insensitive

sock="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
state=normal

# Lua config manager (hyprland.lua): change options with `hyprctl eval`.
# Legacy hyprlang manager (hyprland.conf): fall back to `hyprctl keyword`.
if hyprctl eval 'return true' 2>&1 | grep -q 'only supported with the lua'; then
    set_kb_options() { hyprctl keyword input:kb_options "$1" >/dev/null; }
else
    set_kb_options() { hyprctl eval "hl.config({ [\"input.kb_options\"] = \"$1\" })" >/dev/null; }
fi

set_opts() {
    [[ "$state" == "$1" ]] && return
    state=$1
    if [[ "$state" == gaming ]]; then
        set_kb_options "$GAMING"
    else
        set_kb_options "$NORMAL"
    fi
}

# Always restore the normal layout if this script dies.
trap 'set_opts normal' EXIT

socat -u "UNIX-CONNECT:$sock" - | while IFS= read -r line; do
    [[ "$line" == activewindow\>\>* ]] || continue
    class=${line#activewindow>>}
    class=${class%%,*}
    shopt -s nocasematch
    if [[ "$class" =~ $MATCH ]]; then
        set_opts gaming
    else
        set_opts normal
    fi
    shopt -u nocasematch
done
