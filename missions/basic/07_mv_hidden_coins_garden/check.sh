#!/usr/bin/env sh

# Receives coin number as first argument.
_mission_check() (
    coin_name="$(gettext "coin")_$1"

    n=$(find "$(eval_gettext '$GSH_HOME/Garden')" -maxdepth 1 -name ".*_$coin_name" | wc -l)
    if [ "$n" -gt 1 ]
    then
        echo "$(eval_gettext "There are several '\$coin_name...' in the garden!")"
        return 1
    elif [ "$n" -eq 1 ]
    then
        echo "$(eval_gettext "The coin '\$coin_name...' is still in the garden!")"
        return 1
    fi

    n=$(find "$GSH_CHEST" -maxdepth 1 -name ".*_$coin_name" | wc -l)
    if [ "$n" -gt 1 ]
    then
        echo "$(eval_gettext "There are several '\$coin_name...' in your chest!")"
        return 1
    elif [ "$n" -eq 0 ]
    then
        echo "$(eval_gettext "There is no '\$coin_name...' in your chest!")"
        return 1
    fi

    chest_coin=$(find "$GSH_CHEST" -maxdepth 1 -name ".*_$coin_name")
    # check the coin.
    if ! check_file "$chest_coin"
    then
        echo "$(eval_gettext "The coin '\$coin_name...' has been tampered with...")"
        return 1
    fi

    return 0
)

_mission_check 1 && _mission_check 2 && _mission_check 3
