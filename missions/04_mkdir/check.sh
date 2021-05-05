#!/bin/bash

_local_check() {
    local forest="$(eval_gettext '$GASH_HOME/Forest')"
    local HUT_DIR=$(eval_gettext '$GASH_HOME/Forest')/$(gettext "Hut")

    # Check that there is only one hut.
    local nb_huts
    nb_huts=$(find "$forest" -iname "$(gettext "Hut")" -type d | wc -l)
    if [ "$nb_huts" -ge 2 ]
    then
        echo "$(gettext "You built too many huts in the forest!")"
        return 1
    fi
    if [ "$nb_huts" -lt 1 ]
    then
        echo "$(gettext "You did not build a hut in the forest!")"
        return 1
    fi

    # Check the name of the hut.
    if [ ! -d "$HUT_DIR" ]
    then
        echo "$(eval_gettext 'The $HUT_DIR directory does not exist!')"
        return 1
    fi

    # Check that there is only one chest.
    local nb_chests
    nb_chests=$(find "$forest" -iname "$(gettext "Chest")" -type d | wc -l)
    if [ "$nb_chests" -ge 2 ]
    then
        echo "$(gettext "You built too many chests in your hut!")"
        return 1
    fi
    if [ "$nb_chests" -lt 1 ]
    then
        echo "$(gettext "You did not build a chest in your hut!")"
        return 1
    fi

    # Check that the chest is at the root of the hut.
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
    find "$GASH_HOME" -iname "*$(gettext "Hut")*" -print0 | xargs -0 rm -rf
    find "$GASH_HOME" -iname "*$(gettext "Chest")*" -print0 | xargs -0 rm -rf
    cd "$GASH_HOME"
    echo "$(eval_gettext "You are back at the starting point.")"
    false
fi
