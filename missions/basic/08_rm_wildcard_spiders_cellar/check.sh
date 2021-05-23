#!/bin/bash

_mission_check() {
    local CELLAR="$(eval_gettext "\$GSH_HOME/Castle/Cellar")"

    local nb_spiders=$(find "$CELLAR" -maxdepth 1 -name "*_$(gettext "spider")_*" | wc -l | tr -d ' ')
    if [ "$nb_spiders" -ne 0 ]
    then
        echo "$(eval_gettext "There still are some spiders (\$nb_spiders) in the cellar!")"
        return 1
    fi

    local S1=$(find "$CELLAR" -maxdepth 1 -name "*_$(gettext "bat")_*" | sort | checksum)
    local S2=$(cat "$GSH_VAR/bats")

    if [ "$S1" != "$S2" ]
    then
        echo "$(eval_gettext "Some bats have been modified!")"
        return 1
    fi
    return 0
}

_mission_check
