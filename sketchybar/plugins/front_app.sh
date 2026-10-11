#!/bin/bash
# Shows the focused app name.

if [ "$SENDER" = "front_app_switched" ]; then
  APP="$INFO"
else
  APP="$(aerospace list-windows --focused --format '%{app-name}' 2>/dev/null)"
fi

sketchybar --set "$NAME" label="$APP"
