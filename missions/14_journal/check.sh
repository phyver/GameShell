#!/bin/bash

_local_check() {
    local journal="$GASH_CHEST/$(gettext "journal").txt"
    if [ ! -f "$journal" ]
    then
        journal=~${journal#$GASH_BASE}
        echo "$(eval_gettext "The file '\$journal' doesn't exist...")"
        find "$GASH_HOME" -iname "*$(gettext "journal")*" -print0 | xargs -0 rm -f
        return 1
    elif [ ! -s "$journal" ]
    then
        journal=~${journal#$GASH_BASE}
        echo "$(eval_gettext "The file '\$journal' is empty...")"
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

