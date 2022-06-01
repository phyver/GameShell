#!/bin/sh

_mission_check() (
    maze="$(eval_gettext '$GSH_HOME/Garden/Maze')"

    coin=$(find "$maze" -name "*$(gettext "silver_coin")*")

    if [ -n "$coin" ]
    then
        echo "$(gettext "Ci sono ancora delle monete d'argento nel labirinto!")"
        return 1
    fi

    coin=$(find "$GSH_CHEST" -maxdepth 1 -name "*$(gettext "silver_coin")*")
    if [ -z "$coin" ]
    then
        echo "$(gettext "Non c'e nessuna moneta d'argento nella tua cassa!")"
        return 1
    fi

    if ! cmp -s "$coin" "$GSH_TMP/silver_coin"
    then
        echo "$(gettext "La moneta d'argento nella tua cassa è invalida!")"
        return 1
    fi
)

_mission_check

