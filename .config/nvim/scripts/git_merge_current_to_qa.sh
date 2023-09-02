#!/bin/sh

CURRENT_BRANCH=$(git branch | grep \* | cut -d ' ' -f2)
git checkout QA &&
git pull &&
git merge $CURRENT_BRANCH --commit --no-edit &&
git push &&
git checkout $CURRENT_BRANCH
