#!/bin/bash

# Receives coin number as first argument.
_mission_check() {
    local COIN_NAME="$(gettext "coin")_$1"

    # Check that the coin is not in the cellar.
    if [ -f "$(eval_gettext '$GSH_HOME/Castle/Cellar')/$COIN_NAME" ]
    then
        echo "$(eval_gettext "The coin '\$COIN_NAME' is still in the cellar!")"
        return 1
    fi

    # Check that the coin is in the chest.
    if [ ! -f "$GSH_CHEST/$COIN_NAME" ]
    then
        echo "$(eval_gettext "The coin '\$COIN_NAME' is not in the chest!")"
        return 1
    fi

    # Check that the contents of the coin.
    if ! check_file "$GSH_CHEST/$COIN_NAME"
    then
        echo "$(eval_gettext "The coin '\$COIN_NAME' has been tampered with...")"
        return 1
    fi

    # Verify the checksum in the coin.
    if ! check_file "$GSH_CHEST/$COIN_NAME"
    then
        echo "$(eval_gettext "The coin '\$COIN_NAME' has been tampered with...")"
        return 1
    fi

    return 0
}

if _mission_check 1 && _mission_check 2 && _mission_check 3
then
    unset -f _mission_check
    true
else
    find "$GSH_HOME" -name "$(gettext "coin")_?" -type f -print0 | xargs -0 rm -f
    find "$(eval_gettext '$GSH_HOME/Castle/Cellar')" -iname "*$(gettext "chest")*" -type f -print0 | xargs -0 rm -f
    find "$(eval_gettext '$GSH_HOME/Castle/Cellar')" -iname "*$(gettext "hut")*" -type f -print0 | xargs -0 rm -f
    unset -f _mission_check
    false
fi
