#!/bin/bash

check() {
    local lab=$(find "$GASH_HOME/Chateau/Cave" -name labyrinthe -type d)
    local nb=$(find "$lab" -type f -print0 | xargs -0 grep -l "rubis" | wc -l)

    if [ "$nb" -gt 1 ]
    then
        echo "Il y a trop de rubis dans le labyrinthe !!!"
        return 1
    fi
    if [ "$nb" -ne 0 ]
    then
        echo "Le rubis est encore dans le labyrinthe "
        return 1
    fi

    local rubis=$(find "$GASH_COFFRE" -type f -print0 | xargs -0 grep -l rubis)

    if [ -z "$rubis" ]
    then
        echo "Il n'y a pas de rubis dans le coffre"
        return 1
    fi

    local K=$(cut -f2 -d" " "$rubis")
    local K2=$(basename "$rubis")
    local S=$(cut -f3 -d" " "$rubis")
    local S2=$(checksum "$K.rubis")
    if [ "$K" != "$K2"  -o  "$S" != "$S2" ]
    then
        echo "Le fichier 'rubis' du coffre est invalide..."
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
    find "$GASH_HOME" -type f -readable -not -iname "*journal*" -print0 | xargs -0 grep -l "rubis" | xargs rm -f
    false
fi
