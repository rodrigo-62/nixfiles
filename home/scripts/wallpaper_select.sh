#!/usr/bin/env bash

WALLPAPER_DIR="../wallpapers"

if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send "Error" "Wallpaper directory not found."
    exit 1
fi

cd "$WALLPAPER_DIR" || exit

# Added scrollbar: false; here
SEL=$(ls -1 | rofi -dmenu -i -p "Wallpaper" \
    -theme-str 'window { width: 30%; padding: 15px; }' \
    -theme-str 'listview { columns: 1; lines: 8; scrollbar: false; }')

if [ -z "$SEL" ]; then
    exit 0
fi

# Added the missing \ after 240
swww img "$SEL" \
    --transition-type grow \
    --transition-pos 0.40677,0.6117 \
    --transition-step 240 \
    --transition-fps 144
