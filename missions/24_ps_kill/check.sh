#!/bin/bash

_mission_check() {
    # make sure the generator produces some cats
    echo -n .
    sleep 1
    echo -n .
    sleep 1
    echo .

    local dir=$(eval_gettext '$GSH_HOME/Castle/Kitchen')/$(gettext "Pantry")
    local cat=$(find "$dir" -name "*_$(gettext "wind-up_cat")")

    if [ -n "$cat" ]
    then
        echo "$(gettext "There still are some wind-up cats in the pantry!")"
        return 1
    fi

    cat=$(find "$dir" -name ".*_$(gettext "wind-up_cat")")
    if [ -n "$cat" ]
    then
        echo "$(gettext "There still are some hidden wind-up cats in the pantry!")"
        return 1
    fi

    local sum=$(cat "$dir"/* | checksum)
    if [ "$sum" != "$(cat "$GSH_MISSION_DATA/pantry")" ]
    then
        echo "$(gettext "The content of the pantry has changed!")"
        return 1
    fi

    return 0
}

_mission_check
