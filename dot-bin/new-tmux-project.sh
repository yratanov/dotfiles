#!/bin/bash
# Create a new project under ~/projects and open a tmux session for it
# with two windows: 1) claude, 2) lazygit. Bound to tmux prefix + O.

set -e

PROJECTS_DIR="$HOME/projects"
NAME="$1"

# Sanitize: strip whitespace, reject empty / path separators.
NAME="${NAME#"${NAME%%[![:space:]]*}"}"
NAME="${NAME%"${NAME##*[![:space:]]}"}"

if [ -z "$NAME" ]; then
  tmux display-message "new-project: name is empty"
  exit 0
fi
if [[ "$NAME" == */* ]] || [[ "$NAME" == .* ]]; then
  tmux display-message "new-project: invalid name '$NAME'"
  exit 1
fi

DIR="$PROJECTS_DIR/$NAME"

if tmux has-session -t="$NAME" 2>/dev/null; then
  tmux display-message "new-project: session '$NAME' already exists, switching"
  CURRENT_SESSION=$(tmux display-message -p '#S' 2>/dev/null)
  [ -n "$CURRENT_SESSION" ] && echo "$CURRENT_SESSION" > /tmp/.prev-session
  tmux switch-client -t "$NAME"
  exit 0
fi

mkdir -p "$DIR"
# Initialize git so lazygit opens straight into a repo view.
if [ ! -d "$DIR/.git" ]; then
  git -C "$DIR" init -q
fi

# Window 1: claude. Window 2: lazygit.
tmux new-session -d -s "$NAME" -c "$DIR" -n claude "claude"
tmux new-window -t "$NAME:" -c "$DIR" -n lazygit "lazygit"
tmux select-window -t "$NAME:1"

CURRENT_SESSION=$(tmux display-message -p '#S' 2>/dev/null)
[ -n "$CURRENT_SESSION" ] && echo "$CURRENT_SESSION" > /tmp/.prev-session

if [ -n "$TMUX" ]; then
  tmux switch-client -t "$NAME"
else
  tmux attach-session -t "$NAME"
fi
