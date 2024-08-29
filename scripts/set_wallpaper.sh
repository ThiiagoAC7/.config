#!/bin/bash

WALLPAPER_DIR=~/Wallpapers
WALLPAPER_DARK="$WALLPAPER_DIR/dark"
WALLPAPER_GRUV="$WALLPAPER_DIR/gruvbox"
WALLPAPER_BLUE="$WALLPAPER_DIR/blue_purple"

# get all images under wallpaper dir
IMAGES=("$WALLPAPER_DARK"/* "$WALLPAPER_GRUV"/* "$WALLPAPER_BLUE"/*)

# if no images found, exit
if [ ${#IMAGES[@]} -eq 0 ]; then
    echo "No files found in $WALLPAPER_DIR."
    exit 1
fi

random_image=${IMAGES[RANDOM % ${#IMAGES[@]}]}
WALLPAPER=$random_image

# setting the wallpaper with feh
feh --bg-fill "$WALLPAPER"

echo "Wallpaper set to $WALLPAPER."

# copying current wallpaper to use with i3lock
cp $WALLPAPER /tmp/i3lock.png
