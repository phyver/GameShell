#!/bin/bash

_mission_check() {

    local pid
    pid=$(cat "$GSH_VAR"/fairy.pid)
    if ! ps -cp $pid | grep "$(gettext "nice_fairy")" > /dev/null
    then
        echo "$(gettext "Did you kill the fairy?")"
        return 1
    fi
    pid=$(cat "$GSH_VAR"/imp.pid)
    if ! ps -cp $pid | grep "$(gettext "mischievous_imp")" > /dev/null
    then
        echo "$(gettext "Did you kill the imp?")"
        return 1
    fi

    local nb=$(ps -cp $(cat "$GSH_VAR"/fairy_spell.pids) | grep "$(gettext "spell")" | wc -l)
    if [ "$nb" -lt 3 ]
    then
        echo $nb
        echo "$(gettext "Did you remove some of the fairy's spells?")"
        return 1
    fi

    local nb=$(ps -cp $(cat "$GSH_VAR"/imp_spell.pids) | grep "$(gettext "spell")" | wc -l)
    if [ "$nb" -ne 0 ]
    then
      echo $nb
        echo "$(gettext "Are you sure you removed all the imp's spells?")"
        return 1
    fi

    local cellar=$(eval_gettext '$GSH_HOME/Castle/Cellar')
    local coals=$(find "$cellar" -name "*_$(gettext "coal")" | wc -l)
    if [ "$coals" -ne 0 ]
    then
        echo "$(gettext "There still is some coal in the cellar!")"
        return 1
    fi

    local nl=""
    while ! [ -e "$GSH_VAR/snowflakes.list" ]
    do
      sleep 0.5
      printf "."
      nl="\n"
    done
    printf "$nl"
    cd "$cellar"
    sort "$GSH_VAR"/snowflakes.list 2>/dev/null | uniq > "$GSH_VAR"/snowflakes-generated
    ls *_"$(gettext "snowflake")" 2>/dev/null | sort | uniq > "$GSH_VAR"/snowflakes-present
    # only check for missing snowflakes, and ignore snowflakes that might be present but are
    # not in the list
    local nb=$(comm -1 -3 "$GSH_VAR"/snowflakes-present "$GSH_VAR"/snowflakes-generated | wc -l)

    if [ "$nb" -gt 0 ]
    then
        echo "$(gettext "Did you melt some of the snowflakes?")"
        return 1
    fi
    return 0
}

_mission_check
