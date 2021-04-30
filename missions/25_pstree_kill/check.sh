#!/bin/bash

_local_check() {
    # pour laisser le temps au générateur de faire des chats
    echo -n .
    sleep 1
    echo -n .
    sleep 1
    echo .

    local kitchen=$(eval_gettext '$GASH_HOME/Castle/Kitchen')
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

    nbp=$(ps ax | grep "generator" | wc -l)
    if [ "$nbp" -gt 4 ] # 4, because there is the grep process
    then
        echo "$(gettext "Are you sure you killed all the rat poison generators?")"
        return 1
    elif [ "$nbp" -lt 4 ] # 4, because there is the grep process
    then
        echo "$(gettext "Did you kill some cheese generator?")"
        return 1
    fi

    cd "$kitchen"
    sort "$GASH_MISSION_DATA"/cheese-? | uniq > "$GASH_MISSION_DATA"/cheese-generated
    ls {,.}*_"$(gettext "cheese")" 2>/dev/null | sort | uniq > "$GASH_MISSION_DATA"/cheese-present
    local nb=$(comm -1 -3 "$GASH_MISSION_DATA"/cheese-present "$GASH_MISSION_DATA"/cheese-generated | wc -l)

    if [ "$nb" -gt 1 ]
    then
        echo "$(gettext "Did you eat some cheese?")"
        return 1
    fi
    return 0
}

if _local_check
then
    unset -f _local_check
    true
else
    unset -f _local_check
    false
fi
