#!/bin/bash

_mission_check() {
    # pour laisser le temps au générateur de faire des chats
    echo -n .
    sleep 1
    echo -n .
    sleep 1
    echo .

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

    nbp=$(ps -e | grep "generator" | wc -l)
    if [ "$nbp" -gt 3 ]
    then
        echo "$(gettext "Are you sure you killed all the rat poison generators?")"
        return 1
    elif [ "$nbp" -lt 3 ]
    then
        echo "$(gettext "Did you kill some cheese generator?")"
        return 1
    fi

    cd "$kitchen"
    sort "$GSH_VAR"/cheese-? | uniq > "$GSH_VAR"/cheese-generated
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
