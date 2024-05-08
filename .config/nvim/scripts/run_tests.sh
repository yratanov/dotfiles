#!/bin/bash

if ! tmux list-panes -F '#{pane_index}' | grep -q "$2"; then
  tmux split-window -dh -p 40
fi

tmux send -t "$2" C-c
tmux send -t "$2" -X cancel
tmux send -t "$2" clear Enter
tmux send -t "$2" "$1" Enter

