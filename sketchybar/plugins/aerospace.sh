#!/bin/bash
# Show independent numbered workspaces on each monitor, including empty ones.
# Workspace and display events can overlap; serialize changes to bar items.
if [[ "${1-}" != --locked ]]; then
  exec /usr/bin/lockf -ks -t 0 "${TMPDIR:-/tmp}/aerospace-workspace-bar.lock" /bin/bash "$0" --locked
fi
source "$CONFIG_DIR/colors.sh"

workspaces=$(aerospace list-workspaces --all --json --format '%{workspace} %{monitor-appkit-nsscreen-screens-id} %{workspace-is-visible} %{workspace-is-focused}') || exit 1
monitors=$(aerospace list-monitors --format '%{monitor-id} %{monitor-appkit-nsscreen-screens-id}') || exit 1
screens=$("$CONFIG_DIR/helpers/bin/displays") || exit 1
displays=$(sketchybar --query displays | jq -r '.[] | [.DirectDisplayID, .["arrangement-id"]] | @tsv') || exit 1
items=$(sketchybar --query bar | jq -r '.items[] | select(startswith("space."))') || exit 1
rows=$(printf '%s\n' "$workspaces" | jq -r '.[] | [.workspace, .["monitor-appkit-nsscreen-screens-id"], .["workspace-is-visible"], .["workspace-is-focused"]] | @tsv') || exit 1
current=$'\n'"$items"$'\n'
desired=$'\n'
connected=$'\n'
args=()

# Translate AeroSpace's NSScreen index into SketchyBar's display index and a stable UUID.
map_screen() {
  local screen=$1 index id uuid direct=''
  display=''
  display_uuid=''
  while read -r index id uuid; do
    if [[ "$index" == "$screen" ]]; then direct=$id; display_uuid=$uuid; break; fi
  done <<< "$screens"
  while read -r id index; do
    if [[ "$id" == "$direct" ]]; then display=$index; break; fi
  done <<< "$displays"
}

add_workspace_item() {
  local item=$1 label=$2 target_display=$3 click=$4 visible=$5 focused=$6
  desired+="$item"$'\n'
  if [[ "$current" != *$'\n'"$item"$'\n'* ]]; then
    args+=(--add item "$item" left --set "$item" icon.drawing=off
      label.padding_left=8 label.padding_right=8 padding_left=2 padding_right=2
      background.corner_radius=5 background.height=22 --move "$item" before front_app)
  fi
  args+=(--set "$item" "display=$target_display" "label=$label" "click_script=$click")
  if [[ "$focused" == true ]]; then
    args+=(--set "$item" background.drawing=on "background.color=$WHITE" "label.color=$BLACK")
  elif [[ "$visible" == true ]]; then
    args+=(--set "$item" background.drawing=on background.color=0xff3a3a3a "label.color=$TEXT")
  else
    args+=(--set "$item" background.drawing=off "label.color=$MUTED")
  fi
}

while read -r monitor screen; do
  map_screen "$screen"
  [[ -n "$display" && -n "$display_uuid" ]] || continue
  connected+="$display_uuid"$'\n'
  for number in {1..10}; do
    workspace="monitor_${display_uuid}_${number}"
    visible=false focused=false
    while IFS=$'\t' read -r name row_screen row_visible row_focused; do
      if [[ "$name" == "$workspace" && "$row_screen" == "$screen" ]]; then
        visible=$row_visible; focused=$row_focused; break
      fi
    done <<< "$rows"
    click="aerospace focus-monitor $monitor && /bin/bash \"$HOME/.config/aerospace/workspace.sh\" switch $number"
    add_workspace_item "space.$workspace" "$number" "$display" "$click" "$visible" "$focused"
  done
done <<< "$monitors"

# Keep old workspaces and workspaces from disconnected monitors accessible.
while IFS=$'\t' read -r workspace screen visible focused; do
  [[ -n "$workspace" ]] || continue
  if [[ "$workspace" =~ ^monitor_([A-Fa-f0-9-]+)_([0-9]+)$ ]]; then
    uuid=${BASH_REMATCH[1]}
    label="${BASH_REMATCH[2]}*"
    [[ "$connected" == *$'\n'"$uuid"$'\n'* ]] && continue
  else
    label=$workspace
  fi
  map_screen "$screen"
  [[ -n "$display" ]] || continue
  printf -v quoted '%q' "$workspace"
  add_workspace_item "space.$workspace" "$label" "$display" "aerospace workspace $quoted" "$visible" "$focused"
done <<< "$rows"

while IFS= read -r item; do
  [[ -n "$item" && "$desired" != *$'\n'"$item"$'\n'* ]] && args+=(--remove "$item")
done <<< "$items"

(( ${#args[@]} )) && sketchybar "${args[@]}"
