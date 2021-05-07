#!/bin/bash

_mission_check() {

    local filename="$(head -n1 "$GSH_VAR/painting")"
    local s="$(tail -n1 "$GSH_VAR/painting")"

    if ! [ -d "$GSH_CHEST" ]
    then
        echo "$(eval_gettext "You don't have a chest (\$GSH_CHEST).
Make one first.")"
        return 1
    fi

    local n=$(find "$GSH_CHEST" -name "$(gettext "painting")_*" | wc -l)
    if [ "$n" -eq 0 ]
    then
        echo "$(gettext "There is no painting in your chest...")"
        return 1
    elif [ "$n" -gt 1 ]
    then
        echo "$(gettext "There are too many paintings in your chest...")"
        return 1
    fi

    if [ ! -f "$(eval_gettext '$GSH_HOME/Castle/Main_tower/First_floor')/$filename" ]
    then
        echo "$(gettext "The painting is not in the tower anymore...")"
        return 1
    fi

    if [ ! -f "$GSH_CHEST/$filename" ]
    then
        echo "$(gettext "The painting is not in your chest...")"
        return 1
    fi

    if [ "$s" != "$(checksum < "$GSH_CHEST/$filename")" ]
    then
        echo "$(gettext "The painting in your chest is invalid...")"
        return 1
    fi
}


_mission_check
