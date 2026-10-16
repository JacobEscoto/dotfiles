#!/bin/bash

# Icons are plain SVGs in i3/icons/, coloured to the Kanagawa palette.
# dunst loads them directly via `-i <path>`, so no markup is involved.
# NOTE: do not try to inline Nerd Font glyphs in the text instead --
# dunst's `markup = full` only understands <b>/<i>/<s>/<u>, so a
# <span font="..."> is rendered literally as text.
ICONS="$(cd "$(dirname "${BASH_SOURCE[0]}")/../icons" && pwd)"

# Adjust volume using pamixer (-i volume up, -d volume down, -t toggle mute)
pamixer "$@"

volume=$(pamixer --get-volume)
muted=$(pamixer --get-mute)

if [ "$muted" = "true" ] || [ "$volume" -eq 0 ]; then
  icon="volume-muted.svg"
elif [ "$volume" -lt 34 ]; then
  icon="volume-low.svg"
elif [ "$volume" -lt 67 ]; then
  icon="volume-medium.svg"
else
  icon="volume-high.svg"
fi

# int:value makes dunst draw a progress bar under the notification
dunstify -a "volume" \
  -i "$ICONS/$icon" \
  -h string:x-dunst-stack-tag:volume \
  -h int:value:"$volume" \
  "Volume: $volume%"
