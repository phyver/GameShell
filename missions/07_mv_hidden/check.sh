#!/bin/bash

# Receives coin number as first argument.
_local_check() {
    local COIN=".$(gettext "coin")_$1"

    local n=$(find "$(eval_gettext '$GASH_HOME/Castle/Cellar')" -maxdepth 1 -name "$COIN*" | wc -l)
    if [ "$n" -gt 1 ]
    then
        echo "$(eval_gettext "There are several '\$COIN...' in the cellar!")"
        return 1
    elif [ "$n" -eq 1 ]
    then
        echo "$(eval_gettext "The coin '\$COIN...' is still in the cellar!")"
        return 1
    fi

    local n=$(find "$GASH_CHEST" -maxdepth 1 -name "$COIN*" | wc -l)
    if [ "$n" -gt 1 ]
    then
        echo "$(eval_gettext "There are several '\$COIN...' in your chest!")"
        return 1
    elif [ "$n" -eq 0 ]
    then
        echo "$(eval_gettext "There is no '\$COIN...' in your chest!")"
        return 1
    fi

    local chest_coin=$(find "$GASH_CHEST" -maxdepth 1 -name "$COIN*")
    # Verify the checksum in the coin.
    local COIN_DATA=$(cut -f 1 -d ' ' "$chest_coin")
    local CHECK_SUM=$(cut -f 2 -d ' ' "$chest_coin")
    if [ "$CHECK_SUM" != "$(checksum "$COIN_DATA")" ]
    then
        echo "$(eval_gettext "The coin '\$COIN...' has been tampered with...")"
        return 1
    fi

    # Verify the the checksum also match the file name.
    if [ "$CHECK_SUM" != "$(basename "$chest_coin" | cut -f 3 -d '_')" ]
    then
        echo "$(eval_gettext "The coin '\$COIN...' has a wrong file name...")"
        return 1
    fi

    return 0
}

if _local_check 1 && _local_check 2 && _local_check 3
then
    unset -f _local_check
    unset GASH_CHEST
    true
else
    find "$GASH_HOME" -name ".$(gettext "coin")_?_*" -type f -print0 | xargs -0 rm -f
    find "$(eval_gettext '$GASH_HOME/Castle/Cellar')" -iname "*$(gettext "chest")*" -type f -print0 | xargs -0 rm -f
    find "$(eval_gettext '$GASH_HOME/Castle/Cellar')" -iname "*$(gettext "cabin")*" -type f -print0 | xargs -0 rm -f
    unset -f _local_check
    unset CELLAR GASH_CHEST
    false
fi
