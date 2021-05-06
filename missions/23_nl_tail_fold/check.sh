#!/bin/bash

_mission_check() {
    local goal
    goal=$(REALPATH "$(eval_gettext '$GASH_HOME/Mountain/Cave')")
    local current
    current=$(REALPATH "$PWD")
    if [ "$goal" != "$current" ]
    then
        echo "$(gettext "You are not standing in the cave with the ermit!")"
        return 1
    fi

    local pc
    # TODO: for some unknown reason, redirecting the output of fc into another
    # command shifts the results: it then sees the "gash check" command that
    # was used to run this function
    # I grep the previous command to avoid looping by re-running "gash check"
    # recursively. Because of the previous remark, I need to look at the "-2"
    # command
    pc=$(fc -nl -2 -2 | grep -v check)

    local expected
    expected=$(nl "$(eval_gettext '$MISSION_DIR/recipe/en.txt')" | tail -n 7 | fold -s -w50)
    local res
    res=$(eval "$pc")

    if [ -z "$pc" ]
    then
        echo "$(gettext "You haven't used the operator '|'!")"
        return 1
    fi
    if [ "$res" != "$expected" ]
    then
        echo "$(gettext "Your previous command doesn't give the expected result...")"
        return 1
    fi
    return 0
}


_mission_check
