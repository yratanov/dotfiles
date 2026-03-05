#!/bin/bash

PROJECTS_DIR="$HOME/projects"

# Get alive tmux sessions
ALIVE_SESSIONS=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)

# Build list of projects (directories in ~/projects)
PROJECTS=$(ls -l "$PROJECTS_DIR" | grep '^d' | awk '{print $NF}')

# Build list of tmuxinator configs
TMUXINATORS=$(for f in "$HOME/.config/tmuxinator"/*; do
  [ -f "$f" ] && echo "${f##*/}" | sed 's/\.[^.]*$//'
done)

# Combine all names and deduplicate
ALL_NAMES=$(printf "%s\n%s\n%s" "$ALIVE_SESSIONS" "$PROJECTS" "$TMUXINATORS" | sort -fu | grep -v '^$')

# Build display list: non-alive first, alive sessions at the bottom
CURRENT_SESSION=$(tmux display-message -p '#S' 2>/dev/null)
INACTIVE_LIST=""
ACTIVE_LIST=""
while IFS= read -r name; do
  # Skip current session
  [ "$name" = "$CURRENT_SESSION" ] && continue

  if echo "$ALIVE_SESSIONS" | grep -qx "$name"; then
    ACTIVE_LIST+="● $name"$'\n'
  elif [ -f "$HOME/.config/tmuxinator/$name.yml" ]; then
    INACTIVE_LIST+=" $name"$'\n'
  else
    INACTIVE_LIST+=" $name"$'\n'
  fi
done <<< "$ALL_NAMES"
DISPLAY_LIST="${ACTIVE_LIST}${INACTIVE_LIST}"

SELECTED=$(echo "$DISPLAY_LIST" | grep -v "^$" | fzf-tmux -p)

if [ -z "$SELECTED" ]; then
  exit 0
fi

# Extract marker and name
MARKER=$(echo "$SELECTED" | awk '{print $1}')
NAME=$(echo "$SELECTED" | awk '{print $2}')

if [ "$MARKER" = "●" ]; then
  # Alive session — switch to it
  if [ "$TMUX" ]; then
    echo "$CURRENT_SESSION" > /tmp/.prev-session
    tmux switch-client -t "$NAME"
  else
    tmux attach-session -t "$NAME"
  fi
elif [ -f "$HOME/.config/tmuxinator/$NAME.yml" ]; then
  # Tmuxinator project
  if [ "$TMUX" ]; then
    echo "$CURRENT_SESSION" > /tmp/.prev-session
  fi
  tmuxinator "$NAME"
else
  # Plain project directory
  if [ "$TMUX" ]; then
    echo "$CURRENT_SESSION" > /tmp/.prev-session
    tmux new-session -d -s "$NAME" -c "$PROJECTS_DIR/$NAME"
    tmux switch-client -t "$NAME"
  else
    tmux new-session -As "$NAME" -c "$PROJECTS_DIR/$NAME"
  fi
fi
