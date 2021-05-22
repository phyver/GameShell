#!/bin/bash

_mission_check() {
    local journal_file="$GSH_CHEST/$(gettext "journal").txt"
    if [ ! -f "$journal_file" ]
    then
        journal=~${journal#$GSH_ROOT}
        echo "$(eval_gettext "The file '\$journal_file' doesn't exist...")"
        find "$GSH_HOME" -iname "*$(gettext "journal")*" -print0 | xargs -0 rm -f
        return 1
    elif [ ! -s "$journal_file" ]
    then
        journal=~${journal#$GSH_ROOT}
        echo "$(eval_gettext "The file '\$journal_file' is empty...")"
        find "$GSH_HOME" -iname "*$(gettext "journal")*" -print0 | xargs -0 rm -f
        return 1
    else
        return 0
    fi
}

_mission_check
