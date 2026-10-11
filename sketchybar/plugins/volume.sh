#!/bin/bash
# Volume level. Scroll over it to change volume by 5% per step (volume_change then updates the label).

if [ "$SENDER" = "mouse.scrolled" ]; then
  osascript -e "set volume output volume ((output volume of (get volume settings)) + 5 * $SCROLL_DELTA)"
  exit 0
fi

if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"
else
  VOLUME="$(osascript -e 'output volume of (get volume settings)')"
fi

case "$VOLUME" in
  [6-9][0-9]|100) ICON=󰕾 ;;
  [3-5][0-9])     ICON=󰖀 ;;
  [1-9]|[1-2][0-9]) ICON=󰕿 ;;
  *)              ICON=󰖁 ;;
esac

sketchybar --set "$NAME" icon="$ICON" label="${VOLUME}%"
