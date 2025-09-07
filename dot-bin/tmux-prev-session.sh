#!/bin/bash

PREV_FILE="/tmp/.prev-session"
CURRENT_SESSION=$(tmux display-message -p '#S')

# Read previous session if file exists and not empty
if [[ -s "$PREV_FILE" ]]; then
    PREV_SESSION=$(cat "$PREV_FILE")
else
    PREV_SESSION=""
fi

# Always update prev file for next time
echo "$CURRENT_SESSION" > "$PREV_FILE"

if [[ -n "$PREV_SESSION" ]]; then
    # If prev session exists → switch to it
    tmux switch-client -t "$PREV_SESSION"
else
    # No prev session → look at session list
    SESSIONS=($(tmux list-sessions -F '#S'))
    if [[ "${SESSIONS[0]}" == "$CURRENT_SESSION" ]]; then
        # If current is first → switch to next session
        tmux switch-client -t "${SESSIONS[1]}"
    else
        # Otherwise → switch to first session
        tmux switch-client -t "${SESSIONS[0]}"
    fi
fi
