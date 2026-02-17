#!/bin/bash

TARGET_PANE="$2"

if ! tmux list-panes -F '#{pane_index}' | grep -q "^${TARGET_PANE}$"; then
  tmux split-window -dh -l 40%
  sleep 0.1
fi

tmux send-keys -t "$TARGET_PANE" C-c
tmux send-keys -t "$TARGET_PANE" C-u
tmux send-keys -t "$TARGET_PANE" "clear" Enter
tmux send-keys -t "$TARGET_PANE" "$1" Enter

