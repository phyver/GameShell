#!/bin/bash

_local_check() {
    # make sure the generator produces some cats
    echo -n .
    sleep 1
    echo -n .
    sleep 1
    echo .

    local dir=$(eval_gettext '$GASH_HOME/Castle/Kitchen')/$(gettext "Pantry")
    local cat=$(find "$dir" -name "*_$(gettext "wind-up_cat")")
    local _cat=$(find "$dir" -name ".*_$(gettext "wind-up_cat")")

    if [ -n "$cat" ] || [ -n "$_cats" ]
    then
        echo "$(gettext "There still are some wind-up cats in the pantry!")"
        return 1
    fi

    local sum=$(cat "$dir"/* | checksum)
    if [ "$sum" != "$(cat "$GASH_MISSION_DATA/pantry")" ]
    then
        echo "$(gettext "The content of the pantry has changed!")"
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
    false
fi
