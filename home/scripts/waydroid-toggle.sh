#!/usr/bin/env bash


if systemctl is-active --quiet waydroid-container; then
    notify-send -t 3000 "Waydroid" "Shutting down Android and freeing RAM..."
    waydroid session stop
    sudo systemctl stop waydroid-container
    notify-send -t 2000 "Waydroid" "Powered off."
else
    notify-send -t 4000 "Waydroid" "Starting container and launching Podcast Addict..."
    sudo systemctl start waydroid-container
fi
