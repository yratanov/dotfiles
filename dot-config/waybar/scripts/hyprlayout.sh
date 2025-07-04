#!/bin/bash
# Get the current layout from Hyprland via hyprctl

layout=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap'
)

echo "$layout"
