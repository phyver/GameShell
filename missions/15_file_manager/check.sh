#!/bin/bash

check() {
    local coffre=$(_coffre)
    local lab=$(find $GASH_HOME/Chateau/Cave/ -name "labyrinthe" -type d)
    local piece=$(find "$lab" -name "*bronze*")

    if [ -n "$piece" ]
    then
        echo "Il reste des piéces de bronze dans le labyrinthe..."
        return 1
    fi

    local piece=$(find $coffre -maxdepth 1 -name "*bronze*")
    if [ -z "$piece" ]
    then
        echo "Il n'y a pas de pièce de bronze dans votre coffre..."
        return 1
    fi

    if ! diff -q $piece $GASH_VAR/bronze > /dev/null
    then
        echo "Tricheur : la pièce de bronze qui se trouve dans le coffre n'est pas la bonne !"
        return 1
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
