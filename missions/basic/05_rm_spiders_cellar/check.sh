#!/usr/bin/env sh

_mission_check() (
    cellar="$(eval_gettext '$GSH_HOME/Castle/Cellar')"

    # Check that there are no more spiders.
    spiders=$(find "$cellar" -name "$(gettext "spider")_*")
    if [ -n "$spiders" ]
    then
        echo "$(gettext "There still are spiders in the cellar!")"
        return 1
    fi

    # Check that the bats are still there.
    bats_nb=$(find "$cellar" -name "$(gettext "bat")_*" | wc -l)
    if [ "$bats_nb" -ne 2 ]
    then
        echo "$(gettext "You removed a bat!")"
        return 1
    fi

    return 0
)

_mission_check
