#!/bin/bash

local journal="$GASH_CHEST/$(gettext "journal").txt"
if [ ! -f "$journal" ]
then
    echo "$(eval_gettext "The file '\$journal' doesn't exist...")"
    find "$GASH_HOME" -iname "*$(gettext "journal")*" -print0 | xargs -0 rm -f
    unset journal
    false
elif [ ! -s "$journal" ]
then
    echo "$(eval_gettext "The file '\$journal' is empty...")"
    find "$GASH_HOME" -iname "*$(gettext "journal")*" -print0 | xargs -0 rm -f
    unset journal
    false
else
    unset journal
    return 0
fi
