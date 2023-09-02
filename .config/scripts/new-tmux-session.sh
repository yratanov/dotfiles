#/bin/bash

projects_dir="$HOME/projects"

# fuzzy find a project in projects_dir and create a new tmux session in that dir with the project name
# 
PROJECT=$(ls -l "$projects_dir" | grep '^d' | awk '{print $NF}' | fzf)

if [ $TMUX ]; then
  tmux new-session -d -s $PROJECT -c "$projects_dir/$PROJECT"
  tmux switch-client -t $PROJECT
else
  tmux new-session -As $PROJECT -c "$projects_dir/$PROJECT"
fi
