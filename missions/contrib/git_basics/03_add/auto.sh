#!/usr/bin/env sh

(
    spell=$(gettext "glowing_finger.spl")
    repo="$(eval_gettext '$GSH_HOME/Castle/Lab/Spellbook')"
    cd "$repo"
    git add "$spell"
)
gsh check
