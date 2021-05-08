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

    # Check that the bats are still there.
    local bats_nb
    bats_nb=$(find "$cellar" -name "$(gettext "bat")*" | wc -l)
    if [ "$bats_nb" -ne 2 ]
    then
        echo "$(gettext "Hey! You removed a bat!")"
        return 1
    fi

    return 0
}

_mission_check
