#!/usr/bin/env bash
# Drop the altwin:swap_lalt_lwin xkb option while a Dota 2 window is focused,
# so the physical Alt key is a real Alt in-game (ping wheel, alt-click pings).
# Restores the normal layout as soon as focus leaves Dota.
# Started from hyprland.conf via exec-once.

NORMAL="ctrl:swapcaps,altwin:swap_lalt_lwin"   # must match input:kb_options in hyprland.conf
GAMING="ctrl:swapcaps"
MATCH='^dota2$'                                 # window class, case-insensitive

sock="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
state=normal

set_opts() {
    [[ "$state" == "$1" ]] && return
    state=$1
    if [[ "$state" == gaming ]]; then
        hyprctl keyword input:kb_options "$GAMING" >/dev/null
    else
        hyprctl keyword input:kb_options "$NORMAL" >/dev/null
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
