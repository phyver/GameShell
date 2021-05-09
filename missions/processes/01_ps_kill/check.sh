#!/bin/bash

_mission_check() {
    local pid=$(cat "$GSH_VAR/cat-generator.pid")
    if ps -p $pid | grep cat-generator > /dev/null
    then
        echo "$(gettext "The cat generator is still running!")"
        return 1
    fi

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
    if [ "$sum" != "$(cat "$GSH_VAR/pantry")" ]
    then
        echo "$(gettext "The content of the pantry has changed!")"
        return 1
    fi

    return 0
}

_mission_check
