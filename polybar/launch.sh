#!/usr/bin/env bash

DIR="$HOME/.config/polybar"

# Terminate polybar running instances
killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the main bar
polybar -q main -c "$DIR"/config.ini &
