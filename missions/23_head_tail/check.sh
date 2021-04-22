#!/bin/bash

_local_check() {
    # turn history on (off by default for non-interactive shells
    HISTFILE=$GASH_DATA/history

    local pc
    pc=$(fc -nl -2 -2 | grep '|')

    local goal
    goal=$(CANONICAL_PATH "$(eval_gettext '$GASH_HOME/Mountain/Cave')")
    local current
    current=$(CANONICAL_PATH "$PWD")

    local expected
    expected=$(head -n 11 "$(eval_gettext '$GASH_HOME/Mountain/Cave')/$(gettext "potion_recipe")" | tail -n 3)
    local res
    res=$(eval "$pc")

    if [ "$goal" != "$current" ]
    then
        echo "$(gettext "You are not standing in the cave with the ermit!")"
        return 1
    fi
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


if _local_check
then
    unset -f _local_check
    true
else
    unset -f _local_check
    false
fi
