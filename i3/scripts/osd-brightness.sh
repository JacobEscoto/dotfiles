#!/usr/bin/env bash

# Icons are plain SVGs in i3/icons/, coloured to the Kanagawa palette.
# dunst loads them directly via `-i <path>`, so no markup is involved.
# NOTE: do not try to inline Nerd Font glyphs in the text instead --
# dunst's `markup = full` only understands <b>/<i>/<s>/<u>, so a
# <span font="..."> is rendered literally as text.
ICONS="$(cd "$(dirname "${BASH_SOURCE[0]}")/../icons" && pwd)"

# Adjust brightness with brightnessctl (-q avoids terminal output)
brightnessctl -q "$@"

current=$(brightnessctl get)
max=$(brightnessctl max)
# brightnessctl reports integers on coarse devices but floats on fine-grained
# ones, and bash arithmetic cannot handle floats.
percent=$(awk -v c="$current" -v m="$max" 'BEGIN { printf "%d", (c * 100) / m }')

if [ "$percent" -lt 33 ]; then
  icon="brightness-low.svg"
elif [ "$percent" -lt 66 ]; then
  icon="brightness-medium.svg"
else
  icon="brightness-high.svg"
fi

# int:value makes dunst draw a progress bar under the notification
dunstify -a "brightness" \
  -i "$ICONS/$icon" \
  -h string:x-dunst-stack-tag:brightness \
  -h int:value:"$percent" \
  "Brightness: $percent%"
