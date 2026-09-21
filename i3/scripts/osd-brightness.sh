#!/bin/bash

# Adjusts the brightness with brightnessctl
# '-q' flag avoids terminal output

brightnessctl -q "$@"

current=$(brightnessctl get)
max=$(brightnessctl max)
percent=$((current * 100 / max))

if [ "$percent" -lt 33 ]; then
  icon="display-brightness-low"
elif [ "$percent" -lt 66 ]; then
  icon="display-brightness-medium"
else
  icon="display-brightness-high"
fi

dunstify -a "brightness" -i "$icon" -h string:x-dunst-stack-tag:brightness \
  -h int:value:"$percent" "Brightness: $percent%"
