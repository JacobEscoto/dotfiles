#!/bin/bash

BATTERY="BAT1"
CHECK_INTERVAL=30
WARN_LEVEL=20
CRITICAL_LEVEL=10

STATE_DIR="${XDG_RUNTIME_DIR:-/tmp}/battery-watch"
mkdir -p "$STATE_DIR"
WARNED_20="$STATE_DIR/warned_20"
WARNED_10="$STATE_DIR/warned_10"
FULL_NOTIFIED="$STATE_DIR/full_notified"

rm -f "$WARNED_20" "$WARNED_10" "$FULL_NOTIFIED"

get_capacity() {
  cat "/sys/class/power_supply/$BATTERY/capacity" 2>/dev/null
}

get_status() {
  cat "/sys/class/power_supply/$BATTERY/status" 2>/dev/null
}

get_icon() {
  local pct=$1

  if [ "$pct" -le 10 ]; then
    echo "battery-caution"
  elif [ "$pct" -le 20 ]; then
    echo "battery-low"
  elif [ "$pct" -le 50 ]; then
    echo "battery-good"
  else
    echo "battery-full"
  fi
}

notify() {
  local urgency=$1
  local icon=$2
  local title=$3
  local message=$4

  dunstify -a "battery" -u "$urgency" -i "$icon" -h string:x-dunst-stack-tag:battery \
    "$title" "$message"
}

while true; do
  capacity=$(get_capacity)
  status=$(get_status)

  if [ -z "$capacity" ] || [ -z "$status" ]; then
    sleep "$CHECK_INTERVAL"
    continue
  fi

  if [ "$status" = "Charging" ] || [ "$status" = "Full" ]; then
    rm -f "$WARNED_20" "$WARNED_10"
  fi

  if [ "$status" = "Full" ] && [ ! -f "$FULL_NOTIFIED" ]; then
    notify "normal" "battery-full" "Battery charged" "The battery is full (100%)."
    touch "$FULL_NOTIFIED"
  fi

  if [ "$status" = "Discharging" ] && [ -f "$FULL_NOTIFIED" ]; then
    rm -f "$FULL_NOTIFIED"
  fi

  if [ "$status" = "Discharging" ]; then
    if [ "$capacity" -le "$WARN_LEVEL" ] && [ "$capacity" -gt "$CRITICAL_LEVEL" ] && [ ! -f "$WARNED_20" ]; then
      icon=$(get_icon "$capacity")
      notify "normal" "$icon" "Low battery" "It is left a total of ${capacity}% of battery."
      touch "$WARNED_20"
    fi

    if [ "$capacity" -le "$CRITICAL_LEVEL" ] && [ ! -f "$WARNED_10" ]; then
      icon=$(get_icon "$capacity")
      notify "critical" "$icon" "Critical battery" "It is left a total of ${capacity}% of battery. Connect the charger."
      touch "$WARNED_10"
    fi
  fi

  sleep "$CHECK_INTERVAL"
done
