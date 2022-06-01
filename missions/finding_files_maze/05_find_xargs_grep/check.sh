#!/bin/sh

_mission_check() (
    maze="$(eval_gettext '$GSH_HOME/Garden/Maze')"
    nb=$(find "$maze" -type f -print0 | xargs -0 grep -l "$(gettext "diamante")" | wc -l)

    if [ "$nb" -gt 1 ]
    then
        echo "$(gettext "Ci sono troppi diamanti nel labirinto!")"
        return 1
    fi
    if [ "$nb" -ne 0 ]
    then
        echo "$(gettext "Il diamante è ancora nel labirinto.")"
        return 1
    fi

    diamond=$(find "$GSH_CHEST" -type f -print0 | xargs -0 grep -l "$(gettext "diamond")")

    if [ -z "$diamond" ]
    then
        echo "$(gettext "Non c'è alcun diamante nella tua cassa.")"
        return 1
    fi

    filename=$(cut -d" " -f1 "$GSH_TMP/diamond")

    if ! [ -f "$GSH_CHEST/$filename" ]
    then
        echo "$(gettext "Il diamante non è nella cassa!")"
        return 1
    elif ! cmp -s "$GSH_TMP/diamante" "$GSH_CHEST/$filename"
    then
        echo "$(gettext "Il diamante nella tua cassa non è valido!")"
        return 1
    fi
    return 0
)

_mission_check
