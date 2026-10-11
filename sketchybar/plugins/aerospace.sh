#!/bin/bash
# Highlights the focused AeroSpace workspace. $1 = workspace this item represents.
source "$CONFIG_DIR/colors.sh"

FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"

if [ "$1" = "$FOCUSED" ]; then
  sketchybar --set "$NAME" background.drawing=on label.color="$BLACK"
else
  sketchybar --set "$NAME" background.drawing=off label.color="$MUTED"
fi
