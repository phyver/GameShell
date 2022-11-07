#!/usr/bin/env sh

_mission_check() (
    maze="$(eval_gettext '$GSH_HOME/Garden/Maze')"

    coin=$(find "$maze" -name "*_$(gettext "copper_coin")_*")

    if [ -n "$coin" ]
    then
        echo "$(gettext "There still are some copper coins in the maze!")"
        return 1
    fi

    coin=$(find "$GSH_CHEST" -maxdepth 1 -name "*_$(gettext "copper_coin")_*")
    if [ -z "$coin" ]
    then
        echo "$(gettext "There is no copper coin in your chest!")"
        return 1
    fi

    if ! cmp -s "$coin" "$GSH_TMP/copper_coin"
    then
        echo "$(gettext "Booh... The copper coin in you chest is invalid!")"
        return 1
    fi
)

_mission_check
