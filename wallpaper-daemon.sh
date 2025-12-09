#!/bin/bash
# Daemon script that listens to Hyprland workspace events
# and automatically changes wallpapers based on active workspace

handle() {
  case $1 in
    workspace\>\>*)
      # Extract workspace number from event
      workspace="${1#*>>}"

      # Hardcode wallpaper paths with correct extensions
      case $workspace in
        1)
          wallpaper="/home/nuff/.config/hypr/wallpaper/workspace_1.jpg"
          ;;
        2)
          wallpaper="/home/nuff/.config/hypr/wallpaper/workspace_2.jpeg"
          ;;
        3)
          wallpaper="/home/nuff/.config/hypr/wallpaper/workspace_3.jpg"
          ;;
        4)
          wallpaper="/home/nuff/.config/hypr/wallpaper/workspace_4.jpg"
          ;;
        *)
          wallpaper="/home/nuff/.config/hypr/wallpaper/workspace_${workspace}.jpeg"
          ;;
      esac

      # Set wallpaper for all monitors
      hyprctl hyprpaper wallpaper ",$wallpaper"
      ;;
  esac
}

# Connect to Hyprland event socket and listen for events
socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
