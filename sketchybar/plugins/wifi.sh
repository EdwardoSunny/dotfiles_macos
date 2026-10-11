#!/bin/bash
# Wi-Fi connected/disconnected icon (en0 = Wi-Fi on this Mac).
source "$CONFIG_DIR/colors.sh"

if [ -n "$(ipconfig getifaddr en0)" ]; then
  sketchybar --set "$NAME" icon=󰖩 icon.color="$TEXT"
else
  sketchybar --set "$NAME" icon=󰖪 icon.color="$MUTED"
fi
