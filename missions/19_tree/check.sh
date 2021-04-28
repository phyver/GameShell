#!/bin/bash

_local_check() {
    local maze="$(eval_gettext '$GASH_HOME/Botanical_garden/.Maze')"

    local coin=$(find "$maze" -name "*$(gettext "silver_coin")*")

    if [ -n "$coin" ]
    then
        echo "$(gettext "There still are some silver coins in the maze!")"
        return 1
    fi

    local coin
    coin=$(find "$GASH_CHEST" -maxdepth 1 -name "*$(gettext "silver_coin")*")
    if [ -z "$coin" ]
    then
        echo "$(gettext "There is no silver coin in your chest!")"
        return 1
    fi

    if ! cmp -s "$coin" "$GASH_MISSION_DATA/silver_coin"
    then
        echo "$(gettext "Booh... The silver coin in you chest is invalid!")"
        return 1
    fi
}

if _local_check
then
    unset -f _local_check
    true
else
    unset -f _local_check
    false
fi
