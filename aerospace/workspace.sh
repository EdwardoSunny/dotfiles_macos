#!/bin/bash
# Each physical display has its own workspaces, named with its stable display UUID.
set -e

action=$1
number=$2
if [[ "$action" == move ]]; then
  focused=$(aerospace list-windows --focused --format '%{window-id}%{tab}%{workspace}%{tab}%{monitor-appkit-nsscreen-screens-id}')
  IFS=$'\t' read -r window source screen <<< "$focused"
  [[ -n "$window" && -n "$source" && -n "$screen" ]] || exit 1
else
  screen=$(aerospace list-monitors --focused --format '%{monitor-appkit-nsscreen-screens-id}')
fi
uuid=''
while read -r index direct id; do
  if [[ "$index" == "$screen" ]]; then uuid=$id; break; fi
done < <("${HOME}/.config/sketchybar/helpers/bin/displays")
[[ -n "$uuid" ]] || exit 1
workspace="monitor_${uuid}_${number}"

case "$action" in
  switch)
    # Summon creates or returns the workspace directly on the focused monitor.
    aerospace summon-workspace "$workspace"
    ;;
  move)
    # The window ID, source workspace, and monitor were captured together.
    if [[ "$source" != "$workspace" ]]; then
      aerospace summon-workspace "$workspace"
      aerospace move-node-to-workspace --window-id "$window" "$workspace"
      aerospace summon-workspace "$source"
    fi
    ;;
  *) exit 1 ;;
esac
