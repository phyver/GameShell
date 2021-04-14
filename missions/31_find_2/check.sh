#!/bin/bash

_local_check() {
    local lab
    lab=$(find "$(eval_gettext '$GASH_HOME/Castle/Cellar')" -name "$(gettext "maze")" -type d)
    local nb
    nb=$(find "$lab" -type f -print0 | xargs -0 grep -l "$(gettext "ruby")" | wc -l)

    if [ "$nb" -gt 1 ]
    then
        echo "$(gettext "There are too many rubys in the maze!")"
        return 1
    fi
    if [ "$nb" -ne 0 ]
    then
        echo "$(gettext "The ruby is still in the maze!")"
        return 1
    fi

    local rubis
    rubis=$(find "$GASH_COFFRE" -type f -print0 | xargs -0 grep -l "$(gettext "ruby")")

    if [ -z "$rubis" ]
    then
        echo "$(gettext "There is no ruby in the trunk!")"
        return 1
    fi

    local K
    K=$(cut -f2 -d" " "$rubis")
    local K2
    K2=$(basename "$rubis")
    local S
    S=$(cut -f3 -d" " "$rubis")
    local S2
    S2=$(checksum "$K.$(gettext "ruby")")
    if [ "$K" != "$K2" ] || [ "$S" != "$S2" ]
    then
        echo "$(gettext "The ruby file in the trunk is invalid...")"
        return 1
    fi

    return 0
}


if _local_check
then
    unset -f _local_check
    true
else
    unset -f _local_check
    false
fi
