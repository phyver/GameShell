#!/bin/bash

_local_check() {
    local lab
    lab=$(find "$(eval_gettext '$GASH_HOME/Castle/Cellar')" -name "$(gettext "maze")" -type d)
    echo $lab
    local nb
    nb=$(find "$lab" -type f -print0 | xargs -0 grep -l "$(gettext "ruby")" | wc -l)
    echo $nb

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

    local filename=$(cut -d" " -f1 $GASH_MISSION_DATA/ruby)

    if ! [ -f "$GASH_CHEST/$filename" ]
    then
        echo "$(gettext "The ruby is not in the chest!")"
        return 1
    elif ! cmp -s "$GASH_MISSION_DATA/ruby" "$GASH_CHEST/$filename"
    then
        echo "$(gettext "The ruby in your chest is not valid!")"
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
