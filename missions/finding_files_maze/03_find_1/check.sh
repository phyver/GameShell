#!/bin/bash

_mission_check_p() {
    local COIN_NAME=$1
    local COIN_NB=$2
    local path
    path=$(find "$GSH_CHEST" -name "*$(gettext "$COIN_NAME")_$COIN_NB" -type f)

    if [ -z "$path" ]
    then
        echo "$(gettext "Some of the coins are not in your chest!")"
        echo $COIN_NAME
        return 1
    fi
    if ! cmp -s "$path" "$GSH_VAR/${COIN_NAME}_$COIN_NB"
    then
        echo "$(eval_gettext "Coin '\$COIN_NAME' in your chest is invalid!")"
        return 1
    fi
}

_mission_check() {
    local maze="$(eval_gettext '$GSH_HOME/Garden/Maze')"

    local nb=$(find "$maze" -iname "$(gettext "gold_coin")" -type f | wc -l)
    if [ "$nb" -gt 2 ]
    then
        echo "$(gettext "There are too many gold coins in the maze!")"
        return 1
    fi
    if [ "$nb" -ne 0 ]
    then
        echo "$(gettext "There still are some gold coins in the maze!")"
        return 1
        return 1
    fi

    _mission_check_p "gold_coin" 1 && _mission_check_p "GolD_CoiN" 2
}

find "$GSH_CHEST"
if _mission_check
then
    unset -f _mission_check_p
    true
else
    unset -f _mission_check_p
    find "$GSH_HOME" -iname piece_d_or -not -iname "*journal*" -print0 | xargs -0 rm -f
    false
fi


