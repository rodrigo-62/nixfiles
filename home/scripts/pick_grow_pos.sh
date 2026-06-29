#!/usr/bin/env bash

# 1. Get the resolution of the focused monitor
RES=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .rect | "\(.width) \(.height)"')
WIDTH=$(echo $RES | cut -d' ' -f1)
HEIGHT=$(echo $RES | cut -d' ' -f2)

# 2. Get the click coordinates from slurp
CLICK=$(slurp -p | cut -d' ' -f1)
X=$(echo $CLICK | cut -d',' -f1)
Y=$(echo $CLICK | cut -d',' -f2)

# 3. Calculate normalized coordinates
# We keep X the same, but subtract the Y ratio from 1
NORM_X=$(jq -n "$X / $WIDTH")
NORM_Y=$(jq -n "1 - ($Y / $HEIGHT)")

echo "Normalized Coordinates: $NORM_X,$NORM_Y"
echo "--------------------------------------"
echo "swww img <image> --transition-pos $NORM_X,$NORM_Y"
