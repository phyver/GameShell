#!/bin/bash

_local_check() {
    local cellar
    cellar="$(eval_gettext '$GASH_HOME/Castle/Cellar')"

    # Check that there are no more spiders.
    local spiders
    spiders=$(find "$cellar" -name "$(gettext "spider")*")
    if [ -n "$spiders" ]
    then
        echo "$(gettext "There are still spiders in the cellar!")"
        return 1
    fi

    # Check that the salamander is still there.
    local salamander
    salamander=$(find "$cellar" -name "$(gettext "salamander")*")
    if [ -z "$salamander" ]
    then
        echo "$(gettext "Hey! You removed the salamander!")"
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
