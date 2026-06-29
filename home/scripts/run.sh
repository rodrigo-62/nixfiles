#!/usr/bin/env bash

BASE_DIR="/home/parrhasius/scripts"

declare -a ALLOWED=(
    "$BASE_DIR/encrypt_md"
    "$BASE_DIR/decrypt_md"
    "$BASE_DIR/speed-reading"
)

# Build menu from the whitelist, showing only the folder name
MENU=$(printf "%s\n" "${ALLOWED[@]}" | sed "s|$BASE_DIR/||")

SEL=$(echo "$MENU" | rofi -dmenu -i -p "Run Script" \
    -theme-str 'window { width: 30%; padding: 15px; }' \
    -theme-str 'listview { columns: 1; lines: 10; scrollbar: false; }')

[ -z "$SEL" ] && exit 0

TARGET="$BASE_DIR/$SEL"

# Verify the resolved path is exactly one of the allowed entries
if [[ ! " ${ALLOWED[*]} " =~ " $TARGET " ]]; then
    notify-send "Error" "Blocked: '$TARGET' is not an allowed script directory."
    exit 1
fi

if [ ! -f "$TARGET/shell.nix" ]; then
    notify-send "Error" "No shell.nix found in $TARGET."
    exit 1
fi

foot --app-id=foot-launcher bash -c "cd '$TARGET' && nix-shell; echo ''; read -p 'Press Enter to close…' -r"
