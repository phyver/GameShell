#!/bin/bash

_local_check() {
    local pc
    pc=$(fc -nl -2 -2 | grep 'grep')

    if [ -z "$pc" ]
    then
        return 1
    fi

    if ! diff -q "$GASH_MISSION_DATA/list_grimoires_PQ" <(eval "$pc" |& sort) > /dev/null
    then
        return 1
    else
        return 0
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
