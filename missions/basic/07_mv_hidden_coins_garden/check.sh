#!/usr/bin/env bash

# Receives coin number as first argument.
_mission_check() {
    local COIN_NAME="$(gettext "coin")_$1"

    local n=$(find "$(eval_gettext '$GSH_HOME/Garden')" -maxdepth 1 -name ".*_$COIN_NAME" | wc -l)
    if [ "$n" -gt 1 ]
    then
        echo "$(eval_gettext "There are several '\$COIN_NAME...' in the garden!")"
        return 1
    elif [ "$n" -eq 1 ]
    then
        echo "$(eval_gettext "The coin '\$COIN_NAME...' is still in the garden!")"
        return 1
    fi

    local n=$(find "$GSH_CHEST" -maxdepth 1 -name ".*_$COIN_NAME" | wc -l)
    if [ "$n" -gt 1 ]
    then
        echo "$(eval_gettext "There are several '\$COIN_NAME...' in your chest!")"
        return 1
    elif [ "$n" -eq 0 ]
    then
        echo "$(eval_gettext "There is no '\$COIN_NAME...' in your chest!")"
        return 1
    fi

    local chest_coin=$(find "$GSH_CHEST" -maxdepth 1 -name ".*_$COIN_NAME")
    # check the coin.
    if ! check_file "$chest_coin"
    then
        echo "$(eval_gettext "The coin '\$COIN_NAME...' has been tampered with...")"
        return 1
    fi

    return 0
}

_mission_check 1 && _mission_check 2 && _mission_check 3
