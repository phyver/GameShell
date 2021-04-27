#!/bin/bash

_local_check() {

    local filename="$(head -n1 "$GASH_MISSION_DATA/painting")"
    local s="$(tail -n1 "$GASH_MISSION_DATA/painting")"

    if ! [ -d "$GASH_CHEST" ]
    then
        echo "$(eval_gettext "You don't have a chest (\$GASH_CHEST).
Make one first.")"
        return 1
    fi

    local n=$(find "$GASH_CHEST" -name "$(gettext "painting")_*" | wc -l)
    if [ "$n" -eq 0 ]
    then
        echo "$(gettext "There is no painting in your chest...")"
        return 1
    elif [ "$n" -gt 1 ]
    then
        echo "$(gettext "There are too many paintings in your chest...")"
        return 1
    fi

    if [ ! -f "$(eval_gettext '$GASH_HOME/Castle/Dungeon/First_floor')/$filename" ]
    then
        echo "$(gettext "The painting is not in the dungeon anymore...")"
        return 1
    fi

    if [ ! -f "$GASH_CHEST/$filename" ]
    then
        echo "$(gettext "The painting is not in your chest...")"
        return 1
    fi

    if [ "$s" != "$(checksum < "$GASH_CHEST/$filename")" ]
    then
        echo "$(gettext "The painting in your chest is invalid...")"
        return 1
    fi
}


if _local_check
then
    unset -f _local_check
    true
else
    unset -f _local_check
    false
fi

