#!/bin/bash

mission_check() {

    # adjust
    local MAX_DELAY=20


    local lair="$(find "$(eval_gettext '$GSH_HOME/Castle/Cellar')" -type d -name "$(gettext ".Lair_of_the_spider_queen")*")"
    if [ "$(REALPATH "$(pwd)")" != "$(REALPATH "$lair")" ]
    then
        echo "$(gettext "You are not in the queen spider lair!")"
        return 1
    fi

    local queen=$(find "$lair" -type f -name "*$(gettext "spider_queen")*")
    if [ -n "$queen" ]
    then
        echo "$(gettext "The queen spider is still in its lair...")"
        return 1
    fi
    local bat=$(find "$lair" -type f -name "*$(gettext "baby_bat")*")
    if [ -z "$bat" ]
    then
        echo "$(gettext "Where is the baby bat?")"
        return 1
    fi

    local now=$(date +%s)
    local start=$(cat "$GSH_VAR/start_time")
    local NB_SECONDS=$((now - start))
    if [ "$NB_SECONDS" -gt "$MAX_DELAY" ]
    then
        echo "$(eval_gettext "Good, but you took \$NB_SECONDS seconds. You needed to take less than \$MAX_DELAY seconds...")"
        return 1
    fi

    echo "$(eval_gettext "Perfect, it took you only \$NB_SECONDS seconds to complete this mission!")"
    return 0
}

mission_check
