#!/usr/bin/env sh

(
    repo="$(eval_gettext '$GSH_HOME/Castle/Lab/Spellbook')"
    cd "$repo"
    git add *
    git commit -a -m "lorem ipsum"
)
git rev-parse HEAD | gsh check
