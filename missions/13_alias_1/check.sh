#!/bin/bash

_local_check() {
    local cmd=$(alias la 2> /dev/null | cut -f2 -d"=" | tr -d "' \t")
    if [ -z "$cmd" ]
    then
        echo "$(gettext "The alias 'la' doesn't exist...")"
        return 1
    elif ! la &> /dev/null
    then
        echo "$(gettext "The alias 'la' is invalid...")"
        unalias la
        return 1
    elif [ "$cmd" != 'ls-A' ]
    then
        echo "$(gettext "The alias 'la' doesn't run 'ls -A'...")"
        unalias la
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
