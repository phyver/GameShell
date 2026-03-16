#!/usr/bin/env sh

_mission_check() {
    spell=$(gettext "glowing_finger.spl")
    repo=$(eval_gettext '$GSH_HOME/Castle/Lab/Spellbook')
    spellbook=$(basename "$repo")

    if ! git -C "$repo" rev-parse --is-inside-work-tree
    then
        echo "$(eval_gettext 'Your $spellbook directory is not a git repository.')"
        return 1
    fi

    if [ ! -f "$repo/$spell" ]
    then
        echo $(eval_gettext "The Glowing Finger spell scroll isn't in your \$spellbook repository.")
        return 1
    fi

    # TODO: should we check for other files, staged or not and fail?

    if ! git -C "$repo" status --porcelain | grep "^?? $spell" >/dev/null 2>&1
    then
        echo $(eval_gettext 'The Glowing Finger spell scroll has already been registered into to your $spellbook repository!')
        # TODO: what should we do here?
        # we could git rm --cached the file
        # but what if it has been commited? Should we reset the repo?
        return 1
    fi
    return 0
}
_mission_check
