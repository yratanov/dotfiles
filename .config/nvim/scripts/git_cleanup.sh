#!/bin/bash

git checkout master
git pull
git remote prune origin
git fetch -p && git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -d


