#!/bin/sh

_mission_check() (
    maze="$(eval_gettext '$GSH_HOME/Garden/Maze')"

    coin=$(find "$maze" -name "*_$(gettext "copper_coin")_*")

    if [ -n "$coin" ]
    then
        echo "$(gettext "Ci sono ancora delle monete di bronzo nel labirinto!")"
        return 1
    fi

    coin=$(find "$GSH_CHEST" -maxdepth 1 -name "*_$(gettext "copper_coin")_*")
    if [ -z "$coin" ]
    then
        echo "$(gettext "Non c'è alcuna moneta di bronzo nella tua cassa!")"
        return 1
    fi

    if ! cmp -s "$coin" "$GSH_TMP/copper_coin"
    then
        echo "$(gettext "Buuh... La moneta di bronzo nella tua cassa è invalida!")"
        return 1
    fi
)

_mission_check
