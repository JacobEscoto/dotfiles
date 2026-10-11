#!/usr/bin/env bash

DIR="$HOME/.config/rofi"

ICON_USER=$'\uea00'  # user
ICON_CLOCK=$'\ue939' # clock (uptime)

YES=$'\ue92c' # check
NO=$'\uea12'  # x-circle

lock=$'\ue98f'     # lock
logout=$'\ue991'   # log-out
suspend=$'\ue9a3'  # moon
poweroff=$'\ue9c0' # power
reboot=$'\ue9c4'   # rotate-cw

uptime_str=$(uptime -p | sed -e 's/up //g')

# basic info (user and uptime)
info="<span font_family='feather' foreground='#89DCEB'>${ICON_USER}</span>  ${USER}      \
<span font_family='feather' foreground='#89DCEB'>${ICON_CLOCK}</span>  ${uptime_str}"

menu() {
  rofi -no-config -dmenu -theme "$DIR/powermenu.rasi" "$@"
}

confirm() {
  printf '%s\n%s\n' "$YES" "$NO" |
    rofi -no-config -dmenu -p "Are you sure?" -theme "$DIR/confirm.rasi" -selected-row 1
}

lock_screen() {
  if command -v betterlockscreen &>/dev/null; then
    betterlockscreen -l dimblur || notify-send -u normal "Lock Error" "betterlockscreen failed"
  elif command -v i3lock &>/dev/null; then
    i3lock -c 000000 || notify-send -u normal "Lock Error" "i3lock failed"
  elif command -v loginctl &>/dev/null && loginctl session-status &>/dev/null; then
    loginctl lock-session
  elif command -v xlock &>/dev/null; then
    xlock
  else
    notify-send -u normal "Lock Error" "Install betterlockscreen, i3lock or xlock"
  fi
}

logout_session() {
  local wm="${DESKTOP_SESSION:-$XDG_CURRENT_DESKTOP}"

  if [[ "$wm" == *i3* ]]; then
    i3-msg exit
  elif [[ "$wm" == *sway* ]] || { command -v swaymsg &>/dev/null && swaymsg -t get_version &>/dev/null; }; then
    swaymsg exit
  elif [[ "$wm" == *hyprland* ]] || [[ -n "$HYPRLAND_CMD_SOCK" ]]; then
    hyprctl dispatch exit 0
  elif [[ "$wm" == *bspwm* ]] || command -v bspc &>/dev/null; then
    bspc quit
  elif [[ "$wm" == *openbox* ]]; then
    openbox --exit
  elif [[ "$wm" == *dwm* ]] || pgrep -x dwm &>/dev/null; then
    pkill -15 dwm
  elif [[ "$wm" == *xfce* ]] || command -v xfce4-session-logout &>/dev/null; then
    xfce4-session-logout --logout
  elif [[ "$wm" == *gnome* ]] || command -v gnome-shell &>/dev/null; then
    gnome-session-quit --logout
  elif [[ "$wm" == *plasma* ]] || command -v kquitapp6 &>/dev/null; then
    kquitapp6 plasmashell
  elif command -v loginctl &>/dev/null; then
    loginctl terminate-user "$USER"
  else
    notify-send -u normal "Logout Error" "Unable to determine WM: $wm"
  fi
}

options=$(printf '%s\n' "$lock" "$logout" "$suspend" "$poweroff" "$reboot")
chosen=$(menu -mesg "$info" -selected-row 0 <<<"$options")

# exit if cancelled (Escape key)
[[ -z "$chosen" ]] && exit 0

case "$chosen" in
"$poweroff") [[ "$(confirm)" == "$YES" ]] && systemctl poweroff ;;
"$reboot") [[ "$(confirm)" == "$YES" ]] && systemctl reboot ;;
"$suspend") [[ "$(confirm)" == "$YES" ]] && systemctl suspend ;;
"$lock") lock_screen ;;
"$logout") [[ "$(confirm)" == "$YES" ]] && logout_session ;;
esac
