#!/bin/bash

_mission_check() {
    local pid=$(cat "$GSH_VAR/spell.pid")
    if ps -p $pid | grep spell > /dev/null
    then
        echo "$(gettext "The spell is still running!")"
        return 1
    fi
    return 0
}

_mission_check
