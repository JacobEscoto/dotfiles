#!/usr/bin/env bash

THEME="$HOME/.config/rofi/network-menu.rasi"

ICON_CONNECTED="󰤨"
ICON_WIFI_OFF="󰤭"
ICON_SEARCH="󰩊"

ICON_SIGNAL_LOW="󰤟"
ICON_SIGNAL_MEDIUM="󰤢"
ICON_SIGNAL_HIGH="󰤥"
ICON_SIGNAL_FULL="󰤨"

ICON_SIGNAL_LOW_LOCKED="󰤡"
ICON_SIGNAL_MEDIUM_LOCKED="󰤤"
ICON_SIGNAL_HIGH_LOCKED="󰤧"
ICON_SIGNAL_FULL_LOCKED="󰤪"

rofi_cmd() {
  rofi -dmenu -i -p "Wi-Fi" -theme "$THEME" "$@"
}

rofi_prompt() {
  rofi -dmenu -theme "$THEME" -theme-str 'listview { lines: 0; }' "$@"
}

notify() {
  command -v notify-send &>/dev/null && notify-send -a normal "$1" "$2"
}
get_signal_icon() {
  local signal="$1"
  local is_locked="$2"

  if ! [[ "$signal" =~ ^[0-9]+$ ]]; then
    echo "$ICON_WIFI_OFF"
    return
  fi

  if [[ "$is_locked" == "true" || "$is_locked" == "yes" || "$is_locked" == "WPA"* ]]; then
    if [ "$signal" -ge 75 ]; then
      echo "$ICON_SIGNAL_FULL_LOCKED"
    elif [ "$signal" -ge 50 ]; then
      echo "$ICON_SIGNAL_HIGH_LOCKED"
    elif [ "$signal" -ge 40 ]; then
      echo "$ICON_SIGNAL_MEDIUM_LOCKED"
    else
      echo "$ICON_SIGNAL_LOW_LOCKED"
    fi
  else
    if [ "$signal" -ge 75 ]; then
      echo "$ICON_SIGNAL_FULL"
    elif [ "$signal" -ge 50 ]; then
      echo "$ICON_SIGNAL_HIGH"
    elif [ "$signal" -ge 40 ]; then
      echo "$ICON_SIGNAL_MEDIUM"
    else
      echo "$ICON_SIGNAL_LOW"
    fi
  fi
}

connect_known_or_new() {
  local ssid="$1"
  local security="$2"
  local rc

  if nmcli -t -f NAME connection show | grep -Fxq "$ssid"; then
    nmcli connection up "$ssid" &>/tmp/wifi-menu.log
    rc=$?
  else
    if [[ "$security" == "--" || -z "$security" ]]; then
      nmcli device wifi connect "$ssid" &>/tmp/wifi-menu.log
      rc=$?
    else
      local pass
      pass=$(rofi_prompt -password -p "Password of $ssid")
      if [[ -z "$pass" ]]; then
        return 1
      fi
      nmcli device wifi connect "$ssid" password "$pass" &>/tmp/wifi-menu.log
      rc=$?
    fi
  fi

  if [[ $rc -eq 0 ]]; then
    notify "Wi-Fi" "Connecting to $ssid"
  else
    notify "Wi-Fi" "Error while connecting to $ssid"
  fi
}

manual_ssid() {
  local ssid
  ssid=$(rofi_prompt -p "SSID")
  [[ -z "$ssid" ]] && return
  connect_known_or_new "$ssid" "yes"
}

main_menu() {
  notify "Wi-Fi" "Obtaining all available Wi-Fi networks"

  local status
  status=$(nmcli radio wifi)

  if [[ "$status" == "disabled" ]]; then
    local choice
    choice=$(printf "%s\n" "$ICON_WIFI_OFF  Turn on Wi-Fi" | rofi_cmd)
    if [[ "$choice" == *"Turn on"* ]]; then
      nmcli radio wifi on
      notify "Wi-Fi" "Wi-Fi activated"
    fi
    return
  fi

  declare -A net_map
  local entries=()

  entries+=("$ICON_WIFI_OFF  Turn off Wi-Fi")
  entries+=("$ICON_SEARCH  Search SSID manually")

  while IFS=: read -r inuse ssid security signal; do
    [[ -z "$ssid" ]] && continue

    local is_locked="false"
    if [[ "$security" != "--" && -n "$security" ]]; then
      is_locked="true"
    fi

    local icon
    icon=$(get_signal_icon "$signal" "$is_locked")

    [[ "$inuse" == "*" ]] && icon="$ICON_CONNECTED"

    local label="$icon  $ssid ($signal%)"
    net_map["$label"]="$ssid|$security"
    entries+=("$label")
  done < <(nmcli -t -f IN-USE,SSID,SECURITY,SIGNAL device wifi list --rescan yes | sort -t: -k4 -rn)

  local choice
  choice=$(printf "%s\n" "${entries[@]}" | rofi_cmd)

  case "$choice" in
  "")
    exit 0
    ;;
  "$ICON_WIFI_OFF  Turn off Wi-Fi")
    nmcli radio wifi off
    notify "Wi-Fi" "Wi-Fi deactivated"
    ;;
  "$ICON_SEARCH  Search SSID manually")
    manual_ssid
    ;;
  *)
    IFS='|' read -r ssid security <<<"${net_map[$choice]}"
    [[ -n "$ssid" ]] && connect_known_or_new "$ssid" "$security"
    ;;
  esac
}

main_menu
