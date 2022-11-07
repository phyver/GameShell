#!/usr/bin/env sh

_mission_check() (
    maze="$(eval_gettext '$GSH_HOME/Garden/Maze')"

    coin=$(find "$maze" -name "*$(gettext "silver_coin")*")

    if [ -n "$coin" ]
    then
        echo "$(gettext "There still are some silver coins in the maze!")"
        return 1
    fi

    coin=$(find "$GSH_CHEST" -maxdepth 1 -name "*$(gettext "silver_coin")*")
    if [ -z "$coin" ]
    then
        echo "$(gettext "There is no silver coin in your chest!")"
        return 1
    fi

    if ! cmp -s "$coin" "$GSH_TMP/silver_coin"
    then
        echo "$(gettext "The silver coin in you chest is invalid!")"
        return 1
    fi
)

_mission_check
