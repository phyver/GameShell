#!/bin/bash

_local_check_p() {
    local COIN_NAME=$1
    local path
    path=$(find "$GASH_CHEST" -name "*$(gettext "$COIN_NAME")*" -type f)

    if [ -z "$path" ]
    then
        echo "$(gettext "Some of the coins are not in your chest!")"
        echo $COIN_NAME
        return 1
    fi
    if ! cmp -s "$path" "$GASH_MISSION_DATA/$COIN_NAME"
    then
        echo "$(eval_gettext "Coin '\$COIN_NAME' in your chest is invalid!")"
        return 1
    fi
}

_local_check() {
    local maze="$(eval_gettext '$GASH_HOME/Garden/.Maze')"

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

    _local_check_p "gold_coin" && _local_check_p "GolD_CoiN"
}

if _local_check
then
    unset -f _local_check _local_check_p
    true
else
    unset -f _local_check _local_check_p
    find "$GASH_HOME" -iname piece_d_or -not -iname "*journal*" -print0 | xargs -0 rm -f
    false
fi


