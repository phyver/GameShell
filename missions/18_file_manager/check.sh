#!/bin/bash

_local_check() {
    local lab
    lab=$(find "$GASH_HOME/Chateau/Cave/" -name "labyrinthe" -type d)
    local piece
    piece=$(find "$lab" -name "*bronze*")

    if [ -n "$piece" ]
    then
        echo "Il reste des pièces de bronze dans le labyrinthe..."
        return 1
    fi

    local piece
    piece=$(find "$GASH_COFFRE" -maxdepth 1 -name "*bronze*")
    if [ -z "$piece" ]
    then
        echo "Il n'y a pas de pièce de bronze dans votre coffre..."
        return 1
    fi

    if ! diff -q "$piece" "$GASH_TMP/bronze" > /dev/null
    then
        echo "Tricheur : la pièce de bronze qui se trouve dans le coffre n'est pas la bonne !"
        return 1
    fi
}

if _local_check
then
    unset -f _local_check
    true
else
    unset -f _local_check
    false
fi
