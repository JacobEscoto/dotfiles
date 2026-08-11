#!/usr/bin/env bash

# Resolve script directory & theme location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROFI_DIR="$(dirname "$SCRIPT_DIR")"
THEME="$ROFI_DIR/audio-menu.rasi"

if [[ ! -f "$THEME" ]]; then
  THEME="$HOME/.config/rofi/audio-menu.rasi"
fi

# Fallback default sink & source identifiers
SINK="@DEFAULT_SINK@"
SOURCE="@DEFAULT_SOURCE@"

# Icons
ICON_VOL_HIGH=""
ICON_VOL_MED=""
ICON_VOL_LOW=""
ICON_VOL_MUTE=""
ICON_VOL_UP="󰝝"
ICON_VOL_DOWN="󰝞"
ICON_VOL_SET="󰎤"

ICON_MIC_ON="󰍬"
ICON_MIC_MUTE="󰍭"

ICON_BT_ON="󰂯"
ICON_BT_OFF="󰂲"
ICON_BT_CONN="󰂱"
ICON_BT_DISCONN="󰂴"

ICON_SINK_DEFAULT="󰋋"
ICON_SINK_OTHER="󰓃"
ICON_ACTIVE="󰄬"
ICON_SETTINGS="󰍹"

notify() {
  command -v notify-send &>/dev/null && notify-send -a "Audio Menu" "$1" "$2"
}

rofi_cmd() {
  rofi -dmenu -i -p "$1" -theme "$THEME"
}

rofi_prompt() {
  rofi -dmenu -theme "$THEME" -theme-str 'listview { lines: 0; }' -p "$1"
}

get_volume() {
  pactl get-sink-volume "$SINK" 2>/dev/null | grep -oP '\d+%' | head -n1 | tr -d '%'
}

get_sink_mute() {
  pactl get-sink-mute "$SINK" 2>/dev/null | awk '{print $2}'
}

get_mic_mute() {
  pactl get-source-mute "$SOURCE" 2>/dev/null | awk '{print $2}'
}

get_volume_icon() {
  local vol="$1"
  local mute="$2"
  if [[ "$mute" == "yes" ]]; then
    echo "$ICON_VOL_MUTE"
  elif [ "$vol" -ge 70 ]; then
    echo "$ICON_VOL_HIGH"
  elif [ "$vol" -ge 30 ]; then
    echo "$ICON_VOL_MED"
  else
    echo "$ICON_VOL_LOW"
  fi
}

main_menu() {
  local vol
  vol=$(get_volume)
  [[ -z "$vol" ]] && vol=0

  local mute
  mute=$(get_sink_mute)

  local mic_mute
  mic_mute=$(get_mic_mute)

  local vol_icon
  vol_icon=$(get_volume_icon "$vol" "$mute")

  declare -A action_map
  local entries=()

  # Volume & Mute actions
  if [[ "$mute" == "yes" ]]; then
    local mute_label="$ICON_VOL_MUTE  Unmute Audio (Currently Muted)"
    action_map["$mute_label"]="toggle_mute"
    entries+=("$mute_label")
  else
    local mute_label="$vol_icon  Mute Audio (Current: ${vol}%)"
    action_map["$mute_label"]="toggle_mute"
    entries+=("$mute_label")
  fi

  local vol_up_label="$ICON_VOL_UP  Increase Volume (+5%)"
  action_map["$vol_up_label"]="vol_up"
  entries+=("$vol_up_label")

  local vol_down_label="$ICON_VOL_DOWN  Decrease Volume (-5%)"
  action_map["$vol_down_label"]="vol_down"
  entries+=("$vol_down_label")

  local vol_set_label="$ICON_VOL_SET  Set Custom Volume..."
  action_map["$vol_set_label"]="vol_set"
  entries+=("$vol_set_label")

  # Microphone Mute toggle
  if [[ "$mic_mute" == "yes" ]]; then
    local mic_label="$ICON_MIC_MUTE  Unmute Microphone (Currently Muted)"
    action_map["$mic_label"]="toggle_mic_mute"
    entries+=("$mic_label")
  else
    local mic_label="$ICON_MIC_ON  Mute Microphone (Currently Active)"
    action_map["$mic_label"]="toggle_mic_mute"
    entries+=("$mic_label")
  fi

  # Bluetooth status & toggle button
  local bt_powered=false
  if command -v bluetoothctl &>/dev/null && timeout 1s bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
    bt_powered=true
    local bt_toggle_label="$ICON_BT_OFF  Turn Bluetooth OFF"
    action_map["$bt_toggle_label"]="bt_off"
    entries+=("$bt_toggle_label")
  elif command -v bluetoothctl &>/dev/null; then
    local bt_toggle_label="$ICON_BT_ON  Turn Bluetooth ON"
    action_map["$bt_toggle_label"]="bt_on"
    entries+=("$bt_toggle_label")
  fi

  # 4. Bluetooth Devices (if Bluetooth is ON)
  if [[ "$bt_powered" == "true" ]]; then
    while read -r _ mac dev_name; do
      if [[ -n "$mac" && -n "$dev_name" ]]; then
        if timeout 1s bluetoothctl info "$mac" 2>/dev/null | grep -q "Connected: yes"; then
          local bt_dev_label="$ICON_BT_DISCONN  Disconnect $dev_name"
          action_map["$bt_dev_label"]="bt_disconnect|$mac|$dev_name"
          entries+=("$bt_dev_label")
        else
          local bt_dev_label="$ICON_BT_CONN  Connect $dev_name"
          action_map["$bt_dev_label"]="bt_connect|$mac|$dev_name"
          entries+=("$bt_dev_label")
        fi
      fi
    done < <(timeout 1s bluetoothctl devices 2>/dev/null)
  fi

  # 5. Output Selection (Sinks)
  local default_sink
  default_sink=$(pactl get-default-sink 2>/dev/null)

  local sink_name=""
  local sink_desc=""
  while IFS= read -r line; do
    if [[ "$line" =~ ^Sink\ # ]]; then
      sink_name=""
      sink_desc=""
    elif [[ "$line" =~ Name:\ (.*) ]]; then
      sink_name="${BASH_REMATCH[1]}"
    elif [[ "$line" =~ Description:\ (.*) ]]; then
      sink_desc="${BASH_REMATCH[1]}"
      if [[ -n "$sink_name" && -n "$sink_desc" ]]; then
        local sink_label
        if [[ "$sink_name" == "$default_sink" ]]; then
          sink_label="$ICON_ACTIVE $ICON_SINK_DEFAULT  $sink_desc"
        else
          sink_label="  $ICON_SINK_OTHER  $sink_desc"
        fi
        action_map["$sink_label"]="set_sink|$sink_name|$sink_desc"
        entries+=("$sink_label")
      fi
    fi
  done < <(pactl list sinks 2>/dev/null)

  # 6. Audio Mixer app (pavucontrol) if available
  if command -v pavucontrol &>/dev/null; then
    local mixer_label="$ICON_SETTINGS  Open Volume Control"
    action_map["$mixer_label"]="open_pavucontrol"
    entries+=("$mixer_label")
  fi

  # Prompt title with current status
  local status_str="Audio [Vol: ${vol}%]"
  [[ "$mute" == "yes" ]] && status_str="Audio [Muted]"

  local choice
  choice=$(printf "%s\n" "${entries[@]}" | rofi_cmd "$status_str")

  [[ -z "$choice" ]] && exit 0

  local action="${action_map[$choice]}"
  IFS='|' read -r cmd arg1 arg2 <<<"$action"

  case "$cmd" in
  toggle_mute)
    pactl set-sink-mute "$SINK" toggle
    local new_mute
    new_mute=$(get_sink_mute)
    if [[ "$new_mute" == "yes" ]]; then
      notify "Audio Muted" "Sound has been muted"
    else
      notify "Audio Unmuted" "Volume set to ${vol}%"
    fi
    ;;
  vol_up)
    pactl set-sink-volume "$SINK" +5%
    local new_vol
    new_vol=$(get_volume)
    notify "Volume Increased" "Current volume: ${new_vol}%"
    ;;
  vol_down)
    pactl set-sink-volume "$SINK" -5%
    local new_vol
    new_vol=$(get_volume)
    notify "Volume Decreased" "Current volume: ${new_vol}%"
    ;;
  vol_set)
    local target
    target=$(rofi_prompt "Enter volume (0-100%):")
    if [[ "$target" =~ ^[0-9]+$ ]]; then
      if [ "$target" -gt 150 ]; then
        target=150
      fi
      pactl set-sink-volume "$SINK" "${target}%"
      notify "Volume Set" "Volume set to ${target}%"
    fi
    ;;
  toggle_mic_mute)
    pactl set-source-mute "$SOURCE" toggle
    local new_mic_mute
    new_mic_mute=$(get_mic_mute)
    if [[ "$new_mic_mute" == "yes" ]]; then
      notify "Microphone Muted" "Mic input muted"
    else
      notify "Microphone Active" "Mic input enabled"
    fi
    ;;
  bt_on)
    timeout 2s bluetoothctl power on &>/dev/null
    notify "Bluetooth" "Bluetooth powered ON"
    ;;
  bt_off)
    timeout 2s bluetoothctl power off &>/dev/null
    notify "Bluetooth" "Bluetooth powered OFF"
    ;;
  bt_connect)
    notify "Bluetooth" "Connecting to $arg2..."
    if timeout 5s bluetoothctl connect "$arg1" &>/dev/null; then
      notify "Bluetooth" "Connected to $arg2"
    else
      notify "Bluetooth" "Failed to connect to $arg2"
    fi
    ;;
  bt_disconnect)
    timeout 3s bluetoothctl disconnect "$arg1" &>/dev/null
    notify "Bluetooth" "Disconnected from $arg2"
    ;;
  set_sink)
    pactl set-default-sink "$arg1"
    for input in $(pactl list sink-inputs short 2>/dev/null | awk '{print $1}'); do
      pactl move-sink-input "$input" "$arg1" 2>/dev/null
    done
    notify "Audio Output Changed" "Default sink set to: $arg2"
    ;;
  open_pavucontrol)
    pavucontrol &
    ;;
  esac
}

main_menu
