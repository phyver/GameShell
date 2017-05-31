#!/bin/bash

check() {
    local rats=$(find "$GASH_HOME/Chateau/Cave" -name "rat*")
    if [ -n "$rats" ]
    then
        echo "Il reste des rats dans la cave !"
        return 1
    fi

    local cat=$(find "$GASH_HOME/Chateau/Cave" -name "chat*")
    if [ -z "$cat" ]
    then
        echo "Le chat a disparu !!!"
        return 1
    fi

    return 0
}


if check
then
    unset -f check
    true
else
    unset -f check
    false
fi
