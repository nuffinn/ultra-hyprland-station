#!/bin/bash
# Script to switch wallpaper based on workspace number

workspace=$1

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
