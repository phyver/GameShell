#!/bin/bash

check() {
    local coffre=$(_coffre)
    local lab=$(find $GASH_HOME/Chateau/Cave/ -name "labyrinthe" -type d)
    local piece=$(find "$lab" -name "*argent*")

    if [ -n "$piece" ]
    then
        echo "Il reste des pièces d'argent dans le labyrinthe..."
        return 1
    fi

    local piece=$(find $coffre -maxdepth 1 -name "*argent*")
    if [ -z "$piece" ]
    then
        echo "Il n'y a pas de pièce d'argent dans votre coffre..."
        return 1
    fi

    if ! diff -q $piece $GASH_VAR/argent > /dev/null
    then
        echo "Tricheur : la pièce d'argent qui se trouve dans le coffre n'est pas la bonne !"
        return 1
    fi
}

if check
then
    rm -f $GASH_VAR/argent
    unset -f check
    true
else
    rm -f $GASH_VAR/argent
    find $GASH_HOME -iname "*argent*" | xargs rm -f
    find $GASH_HOME/Chateau/Cave/ -name "labyrinthe" -type d -print0 | xargs -0 rm -rf
    unset -f check
    false
fi
