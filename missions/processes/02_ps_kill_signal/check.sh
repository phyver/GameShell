#!/bin/bash

_mission_check() {
    local nb_spells=$(ps -e | grep "$(gettext "spell")" | wc -l)

    if [ "$nb_spells" -gt 0 ]
    then
        echo "$(eval_gettext "Some spells (\$nb_spells) are still running!")"
        return 1
    fi

    if ! [ -e "$GSH_VAR/spell-term.pids" ]
    then
        echo "$(gettext "You haven't tried using the standard TERM signal on the spell.")"
        return 1
    fi


    return 0
}

_mission_check
