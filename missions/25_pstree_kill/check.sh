#!/bin/bash

_local_check() {
    # pour laisser le temps au générateur de faire des chats
    echo -n .
    sleep 1
    echo -n .
    sleep 1
    echo .

    #TODO : il faudrait aussi vérifier que les fromages sont encore là !!!
    local poison=$(find "$(eval_gettext '$GASH_HOME/Castle/Kitchen')" -name "*_$(gettext "rat_poison")")
    if [ -n "$poison" ]
    then
        echo "$(gettext "There still is some rat poison in the kitchen!")"
        return 1
    fi

    poison=$(find "$(eval_gettext '$GASH_HOME/Castle/Kitchen')" -name ".*_$(gettext "rat_poison")")
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

    # TODO check fork skinner.sh and linguini.sh

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
