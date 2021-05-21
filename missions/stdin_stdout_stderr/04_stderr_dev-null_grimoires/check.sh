#!/bin/bash

_mission_check() {
    local pc
    # TODO: for some unknown reason, redirecting the output of fc into another
    # command shifts the results: it then sees the "gsh check" command that
    # was used to run this function
    # I grep the previous command to avoid looping by re-running "gsh check"
    # recursively. Because of the previous remark, I need to look at the "-2"
    # command
    pc=$(fc -nl -1 -1)

    echo $pc | grep 'gsh\s\s*check' && return 1

    if [ -z "$(echo "$pc" | grep 'grep')" ]
    then
        echo "$(gettext "Your previous command doesn't use the 'grep' command...")"
        return 1
    fi

    if ! diff -q "$GSH_VAR/list_grimoires_PQ" <(eval "$pc" | sort) > /dev/null
    then
        return 1
    else
        return 0
    fi
}


_mission_check
