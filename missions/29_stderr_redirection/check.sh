#!/bin/bash

_local_check() {
    # turn history on (off by default for non-interactive shells
    HISTFILE=$GASH_DATA/history

    local pc
    pc=$(fc -nl -2 -2 | grep 'grep')

    if [ -z "$pc" ]
    then
        return 1
    fi

    if ! diff -q "$GASH_TMP/list_grimoires_PQ" <(eval "$pc" |& sort) > /dev/null
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
