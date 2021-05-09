#!/bin/bash

_mission_check() {
    local JOURNAL_FILE="$GSH_CHEST/$(gettext "journal").txt"
    if [ ! -f "$JOURNAL_FILE" ]
    then
        journal=~${journal#$GSH_ROOT}
        echo "$(eval_gettext "The file '\$JOURNAL_FILE' doesn't exist...")"
        find "$GSH_HOME" -iname "*$(gettext "journal")*" -print0 | xargs -0 rm -f
        return 1
    elif [ ! -s "$JOURNAL_FILE" ]
    then
        journal=~${journal#$GSH_ROOT}
        echo "$(eval_gettext "The file '\$JOURNAL_FILE' is empty...")"
        find "$GSH_HOME" -iname "*$(gettext "journal")*" -print0 | xargs -0 rm -f
        return 1
    else
        return 0
    fi
}

_mission_check
