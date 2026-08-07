#!/usr/bin/env bash

DIR="$HOME/.config/rofi"
uptime=$(uptime -p | sed -e 's/up //g')

rofi_cmd="rofi -no-config -theme $DIR/powermenu.rasi"

YES=""
NO=""

confirm() {
  echo -e "$YES\n$NO" | rofi -dmenu \
    -p "Are you sure?" \
    -theme "$DIR/confirm.rasi" \
    -selected-row 0
}

poweroff="⏻"
reboot=""
lock=""
suspend=""
logout="󰈆"

options="$lock\n$logout\n$suspend\n$poweroff\n$reboot"
chosen="$(echo -e "$options" | $rofi_cmd -p "Uptime: $uptime" -dmenu -selected-row 0)"

case $chosen in
"$poweroff")
  if [[ "$(confirm)" == "$YES" ]]; then
    systemctl poweroff
  fi
  ;;
"$reboot")
  if [[ "$(confirm)" == "$YES" ]]; then
    systemctl reboot
  fi
  ;;
"$lock")
  if [[ -x /usr/bin/i3lock ]]; then
    i3lock
  elif [[ -x /usr/bin/betterlockscreen ]]; then
    betterlockscreen -l
  elif [[ -x /usr/bin/xflock4 ]]; then
    xflock4
  fi
  ;;
"$logout")
  if [[ "$(confirm)" == "$YES" ]]; then
    if [[ -x /usr/bin/xfce4-session-logout ]]; then
      xfce4-session-logout --logout
    fi
  fi
  ;;
"$suspend")
  if [[ "$(confirm)" == "$YES" ]]; then
    if [[ -x /usr/bin/xfce4-session-logout ]]; then
      xfce4-session-logout --suspend
    else
      systemctl suspend
    fi
  fi
  ;;
esac
