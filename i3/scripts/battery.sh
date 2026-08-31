#!/usr/bin/env bash

export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus
export DISPLAY=:0

# Ensure it only exists one instance
pkill -f "battery.sh" 2>/dev/null
sleep 1

notified_20=false
notified_10=false
notified_5=false

while true; do
  battery=$(cat /sys/class/power_supply/BAT1/capacity 2>/dev/null | head -1)
  status=$(cat /sys/class/power_supply/BAT1/status 2>/dev/null | head -1)

  # Full charge notification
  if [ "$battery" -ge 95 ] && [ "$status" == "Charging" ]; then
    notify-send -u critical "Battery" "Complete charge at ${battery}%"
    sleep 300
  fi

  # Reset notifications when charging
  if [ "$status" == "Charging" ]; then
    notified_20=false
    notified_10=false
    notified_5=false
  fi

  if [ "$battery" -le 20 ] && [ "$battery" -gt 10 ] && [ "$notified_20" = false ]; then
    notify-send -u critical "Low battery" "Only ${battery}% available"
    notified_20=true
  fi

  if [ "$battery" -le 10 ] && [ "$battery" -gt 5 ] && [ "$notified_10" = false ]; then
    notify-send -u critical "Low battery" "Only ${battery}% available"
    notified_10=true
  fi

  if [ "$battery" -le 5 ] && [ "$notified_5" = false ]; then
    notify-send -u critical "Critical battery" "Only ${battery}% available - Shutdown soon!"
    notified_5=true
  fi
  sleep 30
done
