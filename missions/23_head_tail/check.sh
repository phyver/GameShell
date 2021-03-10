#!/bin/bash

_local_check() {
    # turn history on (off by default for non-interactive shells
    HISTFILE=$GASH_DATA/history

    local pc
    pc=$(fc -nl -2 -2 | grep '|')

    local goal
    goal=$(CANNONICAL_PATH "$GASH_HOME/Montagne/Grotte")
    local current
    current=$(CANNONICAL_PATH "$PWD")

    local expected
    expected=$(head -n 11 "$GASH_HOME/Montagne/Grotte/recette_potion" | tail -n 3)
    local res
    res=$(eval "$pc")

    if [ "$goal" != "$current" ]
    then
        echo "Vous n'ête pas dans la grotte, avec l'ermite !"
        return 1
    fi
    if [ -z "$pc" ]
    then
        echo "Vous n'avez pas utilisé l'opérateur |"
        return 1
    fi
    if [ "$res" != "$expected" ]
    then
        echo "Votre commande ne fournit pas le bon résultat..."
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
