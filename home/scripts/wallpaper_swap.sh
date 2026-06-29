#!/usr/bin/env bash
# Fast swap script for swww
WALLPAPER_DIR="/etc/nixos/home/wallpapers"
SEL=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

# Transition types: grow, outer, wave, wipe, center, etc.
swww img "$SEL" \
    --transition-type grow \
    --transition-pos 0.9,0.9 \
    --transition-step 90 \
    --transition-fps 60
