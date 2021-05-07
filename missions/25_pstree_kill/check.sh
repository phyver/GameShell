#!/bin/bash

_mission_check() {
    local pid
    pid=$(cat "$GSH_VAR"/linguini.pid)
    if ! ps -p $pid | grep linguini > /dev/null
    then
        local NAME=Linguini
        echo "$(eval_gettext "Did you kill \$NAME?")"
        return 1
    fi
    pid=$(cat "$GSH_VAR"/skinner.pid)
    if ! ps -p $pid | grep skinner > /dev/null
    then
        local NAME=Skinner
        echo "$(eval_gettext "Did you kill \$NAME?")"
        return 1
    fi

    local nb=$(ps -p $(cat "$GSH_VAR"/cheese-generator.pid) | grep generator | wc -l)
    if [ "$nb" -lt 3 ]
    then
        echo "$(gettext "Did you kill some cheese generator?")"
        return 1
    fi

    local nb=$(ps -p $(cat "$GSH_VAR"/poison-generator.pid) | grep generator | wc -l)
    if [ "$nb" -ne 0 ]
    then
        echo "$(gettext "Are you sure you killed all the rat poison generators?")"
        return 1
    fi

    local kitchen=$(eval_gettext '$GSH_HOME/Castle/Kitchen')
    local poison=$(ls "$kitchen"/*_"$(gettext "rat_poison")" 2>/dev/null)
    if [ -n "$poison" ]
    then
        echo "$(gettext "There still is some rat poison in the kitchen!")"
        return 1
    fi

    poison=$(ls "$kitchen"/.*_"$(gettext "rat_poison")" 2>/dev/null)
    if [ -n "$poison" ]
    then
        echo "$(gettext "There still is some rat poison hidden in the kitchen!")"
        return 1
    fi

    cd "$kitchen"
    sort "$GSH_VAR"/cheese-? 2>/dev/null | uniq > "$GSH_VAR"/cheese-generated
    ls {,.}*_"$(gettext "cheese")" 2>/dev/null | sort | uniq > "$GSH_VAR"/cheese-present
    local nb=$(comm -1 -3 "$GSH_VAR"/cheese-present "$GSH_VAR"/cheese-generated | wc -l)

    if [ "$nb" -gt 1 ]
    then
        echo "$(gettext "Did you eat some cheese?")"
        return 1
    fi
    return 0
}

_mission_check
