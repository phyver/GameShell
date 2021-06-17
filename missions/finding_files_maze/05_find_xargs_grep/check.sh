#!/bin/sh

_mission_check() (
    maze="$(eval_gettext '$GSH_HOME/Garden/Maze')"
    nb=$(find "$maze" -type f -print0 | xargs -0 grep -l "$(gettext "diamond")" | wc -l)

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

    diamond=$(find "$GSH_CHEST" -type f -print0 | xargs -0 grep -l "$(gettext "diamond")")

    if [ -z "$diamond" ]
    then
        echo "$(gettext "There is no diamond in your chest.")"
        return 1
    fi

    filename=$(cut -d" " -f1 "$GSH_TMP/diamond")

    if ! [ -f "$GSH_CHEST/$filename" ]
    then
        echo "$(gettext "The diamond is not in the chest!")"
        return 1
    elif ! cmp -s "$GSH_TMP/diamond" "$GSH_CHEST/$filename"
    then
        echo "$(gettext "The diamond in your chest is not valid!")"
        return 1
    fi
    return 0
)

_mission_check
