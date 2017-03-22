#!/bin/bash

# LANG=C jobs | grep "nano.*[Cc]offre/journal.txt" | grep -qi stopped

check() {
    local nb_nano_jobs=$(jobs -s | grep nano | wc -l)

    if [ "$nb_nano_jobs" -ge 2 ]
    then
        echo "Il y a plusieurs processus 'nano' en execution"
        return 1
    elif [ "$nb_nano_jobs" -lt 1 ]
    then
        echo "Il n'y a pas de processus 'nano' en execution"
        return 1
    else
        # if $(jobs -sl | grep nano | grep -iq "journal\.txt")
        # then
        #     return 0
        # else
        #     return 1
        # fi

        local export nano_pid=$(jobs -ps nano)
        # echo "pid : $nano_pid"
        local nano_wd=$(pwdx $nano_pid | cut -d ' ' -f 2)
        # echo "wd : <$nano_wd>"
        local nano_job=$(ps -p $nano_pid -o args | tail -n +2)
        # echo "job : <$nano_job>"
        local file="${nano_job##* }"
        # echo "file : <$file>"
        local file=$(cd "$nano_wd" && readlink -f -- "$file")
        # echo "file : $file"
        local d=$(dirname $file)
        local f=$(basename $file)
        # echo "<$d | $f>"
        local coffre=$(_coffre)

        if [ "$f" != "journal.txt" ]
        then
            echo "Le journal doit s'appeler 'journal.txt'"
            return 1
        fi
        if [ "$d" != "$coffre" ]
        then
            echo "Le journal doit se trouver dans le coffre"
            return 1
        fi
        return 0
    fi
}

if check
then
    unset -f check
    true
else
    unset -f check
    false
fi
