#!/usr/bin/env bash

set -e
# Script for launching my custom polybar (3 blocks) in xfce4
#
#

polybar-msg cmd quit 2>/dev/null || true

sleep 0.5

CONFIG="$HOME/.config/polybar/xfce/config.ini"

polybar -c "$CONFIG" left &
polybar -c "$CONFIG" center &
polybar -c "$CONFIG" right &

wait
