#!/usr/bin/env bash
# Dynamically detect and configure all touchpad devices via libinput / xinput

# Find all device IDs matching TouchPad or touchpad
TOUCHPAD_IDS=$(xinput list --name-only | grep -Ei 'touchpad|trackpoint|synaptics' | while read -r name; do
  xinput list --id-only "$name" 2>/dev/null
done | sort -u)

if [ -z "$TOUCHPAD_IDS" ]; then
  # Fallback to search by props directly if name-based detection was empty
  TOUCHPAD_IDS=$(xinput list --id-only | while read -r id; do
    if xinput list-props "$id" 2>/dev/null | grep -q "libinput Tapping Enabled"; then
      echo "$id"
    fi
  done)
fi

for id in $TOUCHPAD_IDS; do
  # Enable tapping
  xinput set-prop "$id" "libinput Tapping Enabled" 1 2>/dev/null || true
  # Enable natural scrolling (optional, comment out if traditional scroll is preferred)
  xinput set-prop "$id" "libinput Natural Scrolling Enabled" 1 2>/dev/null || true
  # Enable tapping drag lock if available
  xinput set-prop "$id" "libinput Tapping Drag Enabled" 1 2>/dev/null || true
done
