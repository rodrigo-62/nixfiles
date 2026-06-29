#!/usr/bin/env bash

# wl-screenrec is running
if pgrep -x "wl-screenrec" > /dev/null; then
    # send the interrupt signal to stop and save
    pkill -SIGINT wl-screenrec
    notify-send "Screen Recording" "Recording stopped. Saved to ~/Downloads."
else
    # prompt for selection and start recording
    notify-send "Screen Recording" "Select an area to start recording..."
    wl-screenrec --audio -g "$(slurp)" -f ~/Downloads/recording_$(date +'%Y-%m-%d_%H-%M-%S').mp4
fi
