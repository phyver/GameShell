# TODO: limit the number of commands to avoid multiple mv/cd?

CELLAR="$(eval_gettext "\$GASH_HOME/Castle/Cellar")"
CHEST="$(eval_gettext "\$GASH_HOME/Forest/Cabin/Chest")"


# Receives coin number as first argument.
_local_check() {
    local COIN="$(gettext "coin")_$1"

    # Check that the coin is not in the cellar.
    if [ -f "$CELLAR/$COIN" ]
    then
        echo "$(eval_gettext "The coin '\$COIN' is still in the cellar!")"
        return 1
    fi

    # Check that the coin is in the chest.
    if [ ! -f "$CHEST/$COIN" ]
    then
        echo "$(eval_gettext "The coin '\$COIN' is not in the chest!")"
        return 1
    fi

    # Check that the contents of the coin.
    if [ "$(cut -f 1 -d ' ' "$CHEST/$COIN" | cut -f 1 -d '#')" != "$COIN" ]
    then
        echo "$(eval_gettext "The coin '\$COIN' has been tampered with...")"
        return 1
    fi

    # Verify the checksum in the coin.
    local COIN_DATA=$(cut -f 1 -d ' ' "$CHEST/$COIN")
    if [ "$(cut -f 2 -d ' ' "$CHEST/$COIN")" != "$(checksum "$COIN_DATA")" ]
    then
        echo "$(eval_gettext "The coin '\$COIN' has been tampered with...")"
        return 1
    fi

    return 0
}

if _local_check 1 && _local_check 2 && _local_check 3
then
    unset -f _local_check
    unset CELLAR CHEST
    true
else
    find "$GASH_HOME" -name "$(gettext "coin")_?" -type f -print0 | xargs -0 rm -f
    find "$CELLAR" -iname "*$(gettext "chest")*" -type f -print0 | xargs -0 rm -f
    find "$CELLAR" -iname "*$(gettext "cabin")*" -type f -print0 | xargs -0 rm -f
    unset -f _local_check
    unset CELLAR CHEST
    false
fi
