#!/bin/bash

_local_check() {
    local lab
    lab=$(find "$GASH_HOME/Chateau/Cave" -name labyrinthe -type d)
    local nb
    nb=$(find "$lab" -type f -print0 | xargs -0 grep -l "diamant" | wc -l)

    if [ "$nb" -gt 1 ]
    then
        echo "Il y a trop de diamants dans le labyrinthe !!!"
        return 1
    fi
    if [ "$nb" -ne 0 ]
    then
        echo "Le diamant est encore dans le labyrinthe "
        return 1
    fi

    local diamant
    diamant=$(find "$GASH_COFFRE" -type f -print0 | xargs -0 grep -l diamant)

    if [ -z "$diamant" ]
    then
        echo "Il n'y a pas de diamant dans le coffre"
        return 1
    fi

    local K
    K=$(cut -f2 -d" " "$diamant")
    local K2
    K2=$(basename "$diamant")
    local S
    S=$(cut -f3 -d" " "$diamant")
    local S2
    S2=$(checksum "$K.diamant")
    if [ "$K" != "$K2" ] || [ "$S" != "$S2" ]
    then
        echo "Le fichier 'diamant' du coffre est invalide..."
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

