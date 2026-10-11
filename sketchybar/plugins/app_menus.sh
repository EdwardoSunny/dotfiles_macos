#!/bin/bash
# Click on the focused-app name: show that app's menus (File, Edit, …) in a popup under it.
# Clicking a menu opens the real macOS menu. Click the app name again to close.
source "$CONFIG_DIR/colors.sh"
MENUBAR="$CONFIG_DIR/helpers/bin/menubar"

sketchybar --remove '/app_menu\..*/' >/dev/null 2>&1

i=0
while IFS= read -r title; do
  if [ "$i" -eq 0 ]; then title=; fi  # Apple menu
  sketchybar --add item "app_menu.$i" popup.front_app \
    --set "app_menu.$i" \
      icon.drawing=off \
      label="$title" \
      label.color="$TEXT" \
      padding_left=4 \
      padding_right=4 \
      click_script="sketchybar --set front_app popup.drawing=off; $MENUBAR press-menu $i"
  i=$((i + 1))
done < <("$MENUBAR" menus)

sketchybar --set front_app popup.drawing=toggle
