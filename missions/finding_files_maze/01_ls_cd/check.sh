#!/bin/bash

_mission_check() {
    local maze="$(eval_gettext '$GSH_HOME/Garden/Maze')"

    local coin=$(find "$maze" -name "$(gettext "copper_coin")")

    if [ -n "$coin" ]
    then
        echo "$(gettext "There still are some copper coins in the maze!")"
        return 1
    fi

    local coin
    coin=$(find "$GSH_CHEST" -maxdepth 1 -name "$(gettext "copper_coin")")
    if [ -z "$coin" ]
    then
        echo "$(gettext "There is no copper coin in your chest!")"
        return 1
    fi

    if ! cmp -s "$coin" "$GSH_VAR/copper_coin"
    then
        echo "$(gettext "Booh... The copper coin in you chest is invalid!")"
        return 1
    fi
}

_mission_check
