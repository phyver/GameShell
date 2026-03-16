#!/usr/bin/env sh

spell=$(eval_gettext '$GSH_HOME/Castle/Library')/$(gettext "glowing_finger.spl")
repo="$(eval_gettext '$GSH_HOME/Castle/Lab/Spellbook')"
cp "$spell" "$repo"
unset spell repo
gsh check
