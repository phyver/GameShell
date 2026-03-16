#!/usr/bin/env sh

_mission_check() {
    spellbook=$(eval_gettext "Spellbook")
    repo=$(readlink-f "$(eval_gettext "\$GSH_HOME/Castle/Lab/")/$spellbook")
    current=$(readlink-f "$PWD")

    if [ "$(basename "$(pwd)")" != "$(eval_gettext "Spellbook")" ]
    then
        echo "$(eval_gettext 'You are not in the $spellbook directory.')"
        # remove all Spellbook directories
        find "$GSH_HOME" -iname "$spellbook" -print0 | xargs -0 rm -rf
        return 1
    elif [ "$repo" != "$current" ]
    then
        echo "$(eval_gettext 'Your $spellbook directory is not in the Lab directory.')"

        # remove all Spellbook directories
        echo "$(gettext 'You are teleported back to the initial directory.')"
        cd $GSH_HOME
        find "$GSH_HOME" -iname "$spellbook" -print0 | xargs -0 rm -rf
        return 1
    elif ! git -C "$repo" rev-parse --is-inside-work-tree >/dev/null 2>&1
    then
        echo "$(eval_gettext 'Your $spellbook directory is not a git repository.')"
        return 1
    else
        # TODO: should we check the directory is empty and fail otherwise?
        return 0
    fi
}
_mission_check
