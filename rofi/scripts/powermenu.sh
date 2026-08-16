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
  if command -v betterlockscreen &>/dev/null; then
    betterlockscreen -l || notify-send normal "Lock Error" "betterlockscreen failed"
  elif command -v i3lock &>/dev/null; then
    i3lock -c 000000 || notify-send normal "Lock error" "i3lock failed"
  elif command -v loginctl &>/dev/null && loginctl session-status &>/dev/null; then
    loginctl lock-session
  elif command -v xlock &>/dev/null; then
    xlock
  else
    notify-send normal "Lock Error" "Unable to lock your screen. Please try again or install any lock screen manager"
  fi
  ;;
"$logout")
  if [[ "$(confirm)" == "$YES" ]]; then
    wm="${DESKTOP_SESSION:-$XDG_CURRENT_DESKTOP}"
    display="${DISPLAY:-:0}"

    if [[ "$wm" == *"i3"* ]]; then
      i3-msg exit
    elif [[ "$wm" == *"sway"* ]] || command -v swaymsg &>/dev/null && swaymsg -t get_version &>/dev/null; then
      swaymsg exit
    elif [[ "$wm" == *"hyprland"* ]] || [[ "$HYPRLAND_CMD_SOCK" != "" ]]; then
      hyprctl dispatch exit 0
    elif [[ "$wm" == *"bspwm"* ]] || command -v bspc &>/dev/null; then
      bspc quit
    elif [[ "$wm" == *"openbox"* ]]; then
      openbox --exit
    elif [[ "$wm" == *"dwm"* ]] || pgrep -x dwm &>/dev/null; then
      pkill -15 dwm
    elif [[ "$wm" == *"xfce"* ]] || command -v xfce4-session-logout &>/dev/null; then
      xfce4-session-logout --logout
    elif [[ "$wm" == *"gnome"* ]] || command -v gnome-shell &>/dev/null; then
      gnome-session-quit --logout
    elif [[ "$wm" == *"plasmawayland"* ]] || [[ "$wm" == *"plasmashell"* ]] || command -v kquitapp6 &>/dev/null; then
      kquitapp6 plasmashell
    elif command -v loginctl &>/dev/null; then
      loginctl terminate-user "$USER"
    elif [[ -n "$display" ]]; then
      kill -9 -1
    else
      notify-send normal "Logout Error" "Unable to determine WM: $wm"
    fi
  fi
  ;;
"$suspend")
  if [[ "$(confirm)" == "$YES" ]]; then
    systemctl suspend
  fi
  ;;
esac
