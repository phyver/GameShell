#!/bin/sh

_mission_check() (
    maze="$(eval_gettext '$GSH_HOME/Garden/Maze')"

    nb=$(find "$maze" -type f -print0 | xargs -0 grep -l "$(gettext "ruby")" | wc -l)

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

    filename=$(cut -d" " -f1 "$GSH_TMP/ruby")

    if ! [ -f "$GSH_CHEST/$filename" ]
    then
        echo "$(gettext "The ruby is not in the chest!")"
        return 1
    elif ! cmp -s "$GSH_TMP/ruby" "$GSH_CHEST/$filename"
    then
        echo "$(gettext "The ruby in your chest is not valid!")"
        return 1
    fi
    return 0
)

_mission_check
