#!/bin/bash

tmuxsessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)

if [ -z "$tmuxsessions" ]; then
  echo "No tmux sessions running."
  exit 0
fi

choice=$(sort -rfu <<< "$tmuxsessions" | fzf | tr -d '\n')

if [ -z "$choice" ]; then
  exit 0
fi

tmux attach-session -t "$choice"
