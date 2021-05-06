#!/bin/bash

# Receives coin number as first argument.
_mission_check() {
    local COIN_NAME=".$(gettext "coin")_$1"

    local n=$(find "$(eval_gettext '$GASH_HOME/Castle/Cellar')" -maxdepth 1 -name "$COIN_NAME*" | wc -l)
    if [ "$n" -gt 1 ]
    then
        echo "$(eval_gettext "There are several '\$COIN_NAME...' in the cellar!")"
        return 1
    elif [ "$n" -eq 1 ]
    then
        echo "$(eval_gettext "The coin '\$COIN_NAME...' is still in the cellar!")"
        return 1
    fi

    local n=$(find "$GASH_CHEST" -maxdepth 1 -name "$COIN_NAME*" | wc -l)
    if [ "$n" -gt 1 ]
    then
        echo "$(eval_gettext "There are several '\$COIN_NAME...' in your chest!")"
        return 1
    elif [ "$n" -eq 0 ]
    then
        echo "$(eval_gettext "There is no '\$COIN_NAME...' in your chest!")"
        return 1
    fi

    local chest_coin=$(find "$GASH_CHEST" -maxdepth 1 -name "$COIN_NAME*")
    # Verify the checksum in the coin.
    local COIN_DATA=$(cut -f 1 -d ' ' "$chest_coin")
    local CHECK_SUM=$(cut -f 2 -d ' ' "$chest_coin")
    if [ "$CHECK_SUM" != "$(checksum "$COIN_DATA")" ]
    then
        echo "$(eval_gettext "The coin '\$COIN_NAME...' has been tampered with...")"
        return 1
    fi

    # Verify the the checksum also match the file name.
    if [ "$CHECK_SUM" != "$(basename "$chest_coin" | cut -f 3 -d '_')" ]
    then
        echo "$(eval_gettext "The coin '\$COIN_NAME...' has a wrong file name...")"
        return 1
    fi

    return 0
}

# FIXME
if _mission_check 1 && _mission_check 2 && _mission_check 3
then
    unset -f _mission_check
    unset GASH_CHEST
    true
else
    find "$GASH_HOME" -name ".$(gettext "coin")_?_*" -type f -print0 | xargs -0 rm -f
    find "$(eval_gettext '$GASH_HOME/Castle/Cellar')" -iname "*$(gettext "chest")*" -type f -print0 | xargs -0 rm -f
    find "$(eval_gettext '$GASH_HOME/Castle/Cellar')" -iname "*$(gettext "hut")*" -type f -print0 | xargs -0 rm -f
    unset -f _mission_check
    unset CELLAR GASH_CHEST
    false
fi
