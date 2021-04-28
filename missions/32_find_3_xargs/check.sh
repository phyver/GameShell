#!/bin/bash

_local_check() {
    local lab
    lab=$(find "$(eval_gettext '$GASH_HOME/Castle/Cellar')" -name "$(gettext "maze")" -type d)
    local nb
    nb=$(find "$lab" -type f -print0 | xargs -0 grep -l "$(gettext "diamond")" | wc -l)

    if [ "$nb" -gt 1 ]
    then
        echo "$(gettext "There are too many diamonds in the maze!")"
        return 1
    fi
    if [ "$nb" -ne 0 ]
    then
        echo "$(gettext "The diamond is still in the maze.")"
        return 1
    fi

    local diamond
    diamond=$(find "$GASH_CHEST" -type f -print0 | xargs -0 grep -l "$(gettext "diamond")")

    if [ -z "$diamond" ]
    then
        echo "$(gettext "There is no diamond in your chest.")"
        return 1
    fi

    local filename=$(cut -d" " -f1 $GASH_MISSION_DATA/diamond)

    if ! [ -f "$GASH_CHEST/$filename" ]
    then
        echo "$(gettext "The diamond is not in the chest!")"
        return 1
    elif ! cmp -s "$GASH_MISSION_DATA/diamond" "$GASH_CHEST/$filename"
    then
        echo "$(gettext "The diamond in your chest is not valid!")"
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

