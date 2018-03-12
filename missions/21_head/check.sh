#!/bin/bash

check() {
    # turn history on (off by default for non-interactive shells
    HISTFILE=$GASH_DATA/history

    local pc=$(fc -nl -2 -2 | grep 'head')

    local goal=$(readlink -f "$GASH_HOME/Montagne/Grotte")
    local current=$(readlink -f "$PWD")

    local expected=$(head -n 4 "$GASH_HOME/Montagne/Grotte/ingredients_potion")
    local res=$($pc)

    if [ "$goal" != "$current" ]
    then
        echo "Vous n'ête pas dans la grotte, avec l'ermite !"
        return 1
    fi
    if [ -z "$pc" ]
    then
        echo "Vous n'avez pas utilisé la commande head"
        return 1
    fi
    if [ "$res" != "$expected" ]
    then
        echo "Votre commande ne fournit pas le bon résultat..."
        return 1
    fi
    return 0
}


if check
then
    unset -f check
    true
else
    unset -f check
    false
fi
