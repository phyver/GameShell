#!/bin/bash

_local_check() {
    local JOURNAL_FILE="$GASH_CHEST/$(gettext "journal").txt"
    if [ ! -f "$JOURNAL_FILE" ]
    then
        journal=~${journal#$GASH_BASE}
        echo "$(eval_gettext "The file '\$JOURNAL_FILE' doesn't exist...")"
        find "$GASH_HOME" -iname "*$(gettext "journal")*" -print0 | xargs -0 rm -f
        return 1
    elif [ ! -s "$JOURNAL_FILE" ]
    then
        journal=~${journal#$GASH_BASE}
        echo "$(eval_gettext "The file '\$JOURNAL_FILE' is empty...")"
        find "$GASH_HOME" -iname "*$(gettext "journal")*" -print0 | xargs -0 rm -f
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

