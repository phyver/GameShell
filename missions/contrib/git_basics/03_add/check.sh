#!/usr/bin/env sh

_mission_check() {
    spell=$(gettext "glowing_finger.spl")
    repo=$(eval_gettext '$GSH_HOME/Castle/Lab/Spellbook')
    spellbook=$(basename "$repo")

    if ! git -C "$repo" rev-parse --is-inside-work-tree >/dev/null 2>&1
    then
        echo "$(eval_gettext 'Your $spellbook directory is not a git repository.')"
        return 1
    fi

    if [ ! -f "$repo/$spell" ]
    then
        echo "$(eval_gettext 'The Glowing Finger spell scroll is not in your $spellbook repository.')"
        return 1
    fi

    # TODO: should we check for other files, staged or not and fail?

    if git -C "$repo" status --porcelain | grep "^A  $spell" >/dev/null 2>&1
    then
        # OK
        return 0
    fi


    if git -C "$repo" status --porcelain | grep "^?? $spell" >/dev/null 2>&1
    then
        echo "$(eval_gettext "The Glowing Finger spell scroll hasn't been registered into your \$spellbook repository!")"
    elif git -C "$repo" status --porcelain | grep "^AM $spell" >/dev/null 2>&1
    then
        echo "$(gettext "The Glowing Finger spell scroll has been modified.")"
        git -C "$repo" restore "$spell" >/dev/null 2>&1
        git -C "$repo" rm --cached "$spell" >/dev/null 2>&1
    fi
    return 1

}
_mission_check
