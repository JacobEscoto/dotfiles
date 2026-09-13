#!/bin/bash

CAL_WIDTH=260
BAR_OFFSET_Y=38

SCREEN_WIDTH=$(xdotool getdisplaygeometry | cut -d' ' -f1)

POS_X=$(((SCREEN_WIDTH - CAL_WIDTH) / 2))
POS_Y=$BAR_OFFSET_Y

WID_VISIBLE=$(xdotool search --onlyvisible --class "kith" 2>/dev/null)

if [ -n "$WID_VISIBLE" ]; then
  xdotool windowunmap "$WID_VISIBLE"
else
  WID_ALL=$(xdotool search --class "kith" 2>/dev/null)

  if [ -z "$WID_ALL" ]; then
    kith &
    sleep 0.15
    WID_ALL=$(xdotool search --class "kith" 2>/dev/null)
  fi

  xdotool windowmove "$WID_ALL" "$POS_X" "$POS_Y"
  xdotool windowmap "$WID_ALL"
fi
