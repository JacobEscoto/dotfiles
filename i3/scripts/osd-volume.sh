#!/bin/bash

# This script adjusts the volume using pamixer (-i for volume up, -d for volume down, -t for toggle mute)
pamixer "$@"

# Obtain the current volume and the muted state
volume=$(pamixer --get-volume)
muted=$(pamixer --get-mute)

if [ "$muted" = "true" ]; then
  icon="audio-volume-muted"
elif [ "$volume" -eq 0 ]; then
  icon="audio-volume-muted"
elif [ "$volume" -lt 34 ]; then
  icon="audio-volume-low"
elif [ "$volume" -lt 67 ]; then
  icon="audio-volume-medium"
else
  icon="audio-volume-high"
fi

dunstify -a "volume" -i "$icon" -h string:x-dunst-stack-tag:volume -h int:value:"$volume" "Volume: $volume%"
