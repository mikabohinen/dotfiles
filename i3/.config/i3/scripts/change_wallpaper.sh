#!/bin/bash

# Directory containing your wallpapers
WALLPAPER_DIR="$HOME/pictures/wallpapers/"

# Select a random wallpaper
NEW_WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

# Update the symlink to point to the new random wallpaper
ln -sf "$NEW_WALLPAPER" "$XDG_CONFIG_HOME/i3/pywal/wallpaper.jpg"

# Set the new wallpaper
wal -i "$XDG_CONFIG_HOME/i3/pywal/wallpaper.jpg" -q
