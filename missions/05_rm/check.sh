#!/bin/bash

_mission_check() {
    local cellar
    cellar="$(eval_gettext '$GSH_HOME/Castle/Cellar')"

    # Check that there are no more spiders.
    local spiders
    spiders=$(find "$cellar" -name "$(gettext "spider")*")
    if [ -n "$spiders" ]
    then
        echo "$(gettext "There are still spiders in the cellar!")"
        return 1
    fi

    # Check that the salamanders are still there.
    local salamanders_nb
    salamanders_nb=$(find "$cellar" -name "$(gettext "salamander")*" | wc -l)
    if [ "$salamanders_nb" -ne 2 ]
    then
        echo "$(gettext "Hey! You removed a salamander!")"
        return 1
    fi

    return 0
}

_mission_check
