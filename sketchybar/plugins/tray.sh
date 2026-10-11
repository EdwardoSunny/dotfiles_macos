#!/bin/bash
# Shows the app icon only while its process is running. $1 = pgrep -f pattern.

if pgrep -f "$1" >/dev/null; then
  sketchybar --set "$NAME" drawing=on
else
  sketchybar --set "$NAME" drawing=off
fi
