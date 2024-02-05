#!/bin/bash
tmuxsessions=$(tmux list-sessions -F "#{session_name}")

tmux_switch_to_session() {
    session="$1"
    if [[ $tmuxsessions = *"$session"* ]]; then
        tmux switch-client -t "$session"
    fi
}

CURRENT_SESSION=$(tmux display-message -p '#S')
PREV_SESSION=$(cat /tmp/.prev-session)

choice=$(sort -rfu <<< "$tmuxsessions" \
    | grep -v "^$CURRENT_SESSION$" \
    | fzf-tmux -p \
    | tr -d '\n')

if [ -z "$choice" ]; then
    exit 0
fi
echo $CURRENT_SESSION > /tmp/.prev-session

tmux_switch_to_session "$choice"


