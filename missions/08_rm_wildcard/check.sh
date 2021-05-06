#!/bin/bash

_mission_check() {
    local CELLAR="$(eval_gettext "\$GASH_HOME/Castle/Cellar")"

    local NB_SPIDERS=$(find "$CELLAR" -maxdepth 1 -name "*$(gettext "spider")" | wc -l)
    if [ "$NB_SPIDERS" -ne 0 ]
    then
        echo "$(eval_gettext "There still are some spiders (\$NB_SPIDERS) in the cellar!")"
        return 1
    fi

    local S1=$(find "$CELLAR" -maxdepth 1 -name ".*$(gettext "salamander")" | sort | checksum)
    local S2=$(cat "$GASH_MISSION_DATA/salamanders")

    if [ "$S1" != "$S2" ]
    then
        echo "$(eval_gettext "Some salamanders have been modified!")"
        return 1
    fi
    return 0
}

_mission_check
