#!/usr/bin/env sh

repo="$(eval_gettext '$GSH_HOME/Castle/Lab/Spellbook')"
library=$(eval_gettext '$GSH_HOME/Castle/Library')
spell=$(gettext "glowing_finger.spl")

rm -f "$repo/$spell"
gsh assert check false

cp "$library/$spell" "$repo"
(
    cd "$repo"
    git add "$(gettext "glowing_finger.spl")" >/dev/null 2>&1
)
gsh assert check false

(
    cd "$repo"
    git rm --cached "$(gettext "glowing_finger.spl")" >/dev/null 2>&1
)
cp "$library/$spell" "$repo"
gsh assert check true

unset spell repo
