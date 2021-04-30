#!/bin/bash

_local_check() {
    local forest="$(eval_gettext '$GASH_HOME/Forest')"
    local cabin=$(eval_gettext '$GASH_HOME/Forest')/$(gettext "Cabin")

    # Check that there is only one cabin.
    local nb_cabins
    nb_cabins=$(find "$forest" -iname "$(gettext "Cabin")" -type d | wc -l)
    if [ "$nb_cabins" -ge 2 ]
    then
        echo "$(gettext "You built too many cabins in the forest!")"
        return 1
    fi
    if [ "$nb_cabins" -lt 1 ]
    then
        echo "$(gettext "You did not build a cabin in the forest!")"
        return 1
    fi

    # Check the name of the cabin.
    if [ ! -d "$cabin" ]
    then
        echo "$(eval_gettext 'The $cabin directory does not exist!')"
        return 1
    fi

    # Check that there is only one chest.
    local nb_chests
    nb_chests=$(find "$forest" -iname "$(gettext "Chest")" -type d | wc -l)
    if [ "$nb_chests" -ge 2 ]
    then
        echo "$(gettext "You built too many chests in your cabin!")"
        return 1
    fi
    if [ "$nb_chests" -lt 1 ]
    then
        echo "$(gettext "You did not build a chest in your cabin!")"
        return 1
    fi

    # Check that the chest is at the root of the cabin.
    local chest
    if ! [ -d "$GASH_CHEST" ]
    then
        echo "$(eval_gettext "The \$GASH_CHEST directory does not exist!")"
        return 1
    fi

    return 0
}

if _local_check
then
    unset -f _local_check
    true
else
    unset -f _local_check
    find "$GASH_HOME" -iname "*$(gettext "Cabin")*" -print0 | xargs -0 rm -rf
    find "$GASH_HOME" -iname "*$(gettext "Chest")*" -print0 | xargs -0 rm -rf
    cd "$GASH_HOME"
    echo "$(eval_gettext "You are back at the starting point.")"
    false
fi
