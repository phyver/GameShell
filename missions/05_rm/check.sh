#!/bin/bash

_local_check() {
    local rats
    rats=$(find "$GASH_HOME/Chateau/Cave" -name "rat*")
    if [ -n "$rats" ]
    then
        echo "Il reste des rats dans la cave !"
        return 1
    fi

    local cat
    cat=$(find "$GASH_HOME/Chateau/Cave" -name "chat*")
    if [ -z "$cat" ]
    then
        echo "Le chat a disparu !!!"
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
