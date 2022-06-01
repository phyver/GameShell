#!/bin/sh

_mission_check() (
    maze="$(eval_gettext '$GSH_HOME/Garden/Maze')"

    nb=$(find "$maze" -type f -print0 | xargs -0 grep -l "$(gettext "ruby")" | wc -l)

    if [ "$nb" -gt 1 ]
    then
        echo "$(gettext "Ci sono troppi rubini nel labirinto!")"
        return 1
    fi
    if [ "$nb" -ne 0 ]
    then
        echo "$(gettext "Il rubino è ancora nel labirinto!")"
        return 1
    fi

    filename=$(cut -d" " -f1 "$GSH_TMP/ruby")

    if ! [ -f "$GSH_CHEST/$filename" ]
    then
        echo "$(gettext "Il rubino non è nella cassa!")"
        return 1
    elif ! cmp -s "$GSH_TMP/ruby" "$GSH_CHEST/$filename"
    then
        echo "$(gettext "Il rubino nella tua cassa non è valido!")"
        return 1
    fi
    return 0
)

_mission_check
