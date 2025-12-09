#!/bin/bash
# Script to switch wallpaper based on workspace number

workspace=$1
wallpaper="/home/nuff/.config/hypr/wallpaper/workspace_${workspace}.jpeg"

# Set wallpaper for all monitors
hyprctl hyprpaper wallpaper ",$wallpaper"
