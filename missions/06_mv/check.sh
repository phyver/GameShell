#!/bin/bash

# Receives coin number as first argument.
_local_check() {
    local COIN_NAME="$(gettext "coin")_$1"

    # Check that the coin is not in the cellar.
    if [ -f "$(eval_gettext '$GASH_HOME/Castle/Cellar')/$COIN_NAME" ]
    then
        echo "$(eval_gettext "The coin '\$COIN_NAME' is still in the cellar!")"
        return 1
    fi

    # Check that the coin is in the chest.
    if [ ! -f "$GASH_CHEST/$COIN_NAME" ]
    then
        echo "$(eval_gettext "The coin '\$COIN_NAME' is not in the chest!")"
        return 1
    fi

    # Check that the contents of the coin.
    if [ "$(cut -f 1 -d ' ' "$GASH_CHEST/$COIN_NAME" | cut -f 1 -d '#')" != "$COIN_NAME" ]
    then
        echo "$(eval_gettext "The coin '\$COIN_NAME' has been tampered with...")"
        return 1
    fi

    # Verify the checksum in the coin.
    local coin_data=$(cut -f 1 -d ' ' "$GASH_CHEST/$COIN_NAME")
    if [ "$(cut -f 2 -d ' ' "$GASH_CHEST/$COIN_NAME")" != "$(checksum "$coin_data")" ]
    then
        echo "$(eval_gettext "The coin '\$COIN_NAME' has been tampered with...")"
        return 1
    fi

    return 0
}

if _local_check 1 && _local_check 2 && _local_check 3
then
    unset -f _local_check
    true
else
    find "$GASH_HOME" -name "$(gettext "coin")_?" -type f -print0 | xargs -0 rm -f
    find "$(eval_gettext '$GASH_HOME/Castle/Cellar')" -iname "*$(gettext "chest")*" -type f -print0 | xargs -0 rm -f
    find "$(eval_gettext '$GASH_HOME/Castle/Cellar')" -iname "*$(gettext "hut")*" -type f -print0 | xargs -0 rm -f
    unset -f _local_check
    false
fi
