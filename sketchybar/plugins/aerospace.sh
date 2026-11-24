#!/bin/bash
# Refresh workspace placement and mark the visible workspace on each display.
source "$CONFIG_DIR/colors.sh"

workspaces=$(aerospace list-workspaces --all --json --format '%{workspace} %{monitor-appkit-nsscreen-screens-id} %{workspace-is-visible} %{workspace-is-focused}') || exit 1
# Workspace names can appear or disappear after SketchyBar starts.
current_items=$(sketchybar --query bar | jq -r '.items[] | select(startswith("space.")) | ltrimstr("space.")' | sort)
current_workspaces=$(printf '%s\n' "$workspaces" | jq -r '.[].workspace' | sort)
if [[ "$current_items" != "$current_workspaces" ]]; then
  sketchybar --reload
  exit
fi
screens=$("$CONFIG_DIR/helpers/bin/displays") || exit 1
displays=$(sketchybar --query displays | jq -r '.[] | [.DirectDisplayID, .["arrangement-id"]] | @tsv') || exit 1

args=()
while IFS=$'\t' read -r workspace screen visible focused; do
  direct=''
  display=''
  while read -r index id; do
    [[ "$index" == "$screen" ]] && direct="$id" && break
  done <<< "$screens"
  while read -r id arrangement; do
    [[ "$id" == "$direct" ]] && display="$arrangement" && break
  done <<< "$displays"
  [[ -n "$display" ]] || continue

  if [[ "$focused" == true ]]; then
    args+=(--set "space.$workspace" "display=$display" background.drawing=on "background.color=$WHITE" "label.color=$BLACK")
  elif [[ "$visible" == true ]]; then
    args+=(--set "space.$workspace" "display=$display" background.drawing=on background.color=0xff3a3a3a "label.color=$TEXT")
  else
    args+=(--set "space.$workspace" "display=$display" background.drawing=off "label.color=$MUTED")
  fi
done < <(printf '%s\n' "$workspaces" | jq -r '.[] | [.workspace, .["monitor-appkit-nsscreen-screens-id"], .["workspace-is-visible"], .["workspace-is-focused"]] | @tsv')

(( ${#args[@]} )) && sketchybar "${args[@]}"
