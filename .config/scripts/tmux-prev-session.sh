#!/bin/bash
PREV_SESSION=$(cat /tmp/.prev-session)
CURRENT_SESSION=$(tmux display-message -p '#S')
echo $CURRENT_SESSION > /tmp/.prev-session

tmux switch-client -t $PREV_SESSION
