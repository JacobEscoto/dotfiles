#!/bin/env bash

# lock.sh locks the screen by using betterlockscreen
# It locks using a blurry effect on the wallpaper

if command -v betterlockscreen &>/dev/null; then
  betterlockscreen -l dimblur
else
  notify-send -u normal "Could not lock the screen successfully" "Please make sure to have installed betterlockscreen"
fi
