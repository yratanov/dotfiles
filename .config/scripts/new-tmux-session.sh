#!/bin/bash

PROJECTS_DIR="$HOME/projects"

# fuzzy find a project in PROJECTS_DIR and create a new tmux session in that dir with the project name
# 
PROJECTS=$(ls -l "$PROJECTS_DIR" | grep '^d' | awk '{print " ", $NF}')

TMUXINATORS=$(tmuxinator list | tail -n 1 | tr -s "[:space:]" "\n" | awk '{print  " ", $1}')

SELECTED=$(printf "$PROJECTS\n$TMUXINATORS" | fzf-tmux)


if [[ $SELECTED == *""* ]]; then
  tmuxinator $(echo $SELECTED | awk '{print $2}')
else
  SELECTED=$(echo $SELECTED | awk '{print $2}')

  if [ $TMUX ]; then
    tmux new-session -d -s $SELECTED -c "$PROJECTS_DIR/$SELECTED"
    tmux switch-client -t $SELECTED
  else
    tmux new-session -As $SELECTED -c "$PROJECTS_DIR/$SELECTED"
  fi
fi
