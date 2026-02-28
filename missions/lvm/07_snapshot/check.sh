#!/usr/bin/env sh

_mission_check() (
    if ! [ -e "/dev/esdea/ouskelcoule_snap" ]; then
        echo "$(eval_gettext "The backup of the village of Ouskelcoule is still missing.")"
        return 1
    fi

    if ! [ -e "/dev/esdea/douskelpar_snap" ]; then
        echo "$(eval_gettext "The backup of the village of Douskelpar is still missing.")"
        return 1
    fi

    if ! [ -e "/dev/esdebe/grandflac_snap" ]; then
        echo "$(eval_gettext "The backup of the village of Grandflac is still missing.")"
        return 1
    fi

    echo "$(eval_gettext "Bravo! Ouskelcoule, Douskelpar and Grandflac are well archived, ready to be restored if necessary!")"
    return 0
)
    
_mission_check
