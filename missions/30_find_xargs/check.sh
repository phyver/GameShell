#!/bin/bash

check() {
    local lab=$(find $GASH_HOME/Chateau/Cave -name labyrinthe -type d)
    local nb=$(find "$lab" -type f -print0 | xargs -0 grep -l "diamant" | wc -l)

    if [ $nb -gt 1 ]
    then
        echo "Il y a trop de diamants dans le labyrinthe !!!"
        return 1
    fi
    if [ $nb -ne 0 ]
    then
        echo "Le diamant est encore dans le labyrinthe "
        return 1
    fi

    local coffre=$(_coffre)
    local diamant=$(find $coffre -type f | xargs grep -l diamant)

    if [ -z "$diamant" ]
    then
        echo "Il n'y a pas de diamant dans le coffre"
        return 1
    fi

    local K=$(cut -f2 -d" " $diamant)
    local K2=$(basename $diamant)
    local S=$(cut -f3 -d" " $diamant)
    local S2=$(checksum $K.diamant)
    if [ "$K" != "$K2"  -o  "$S" != "$S2" ]
    then
        echo "Le fichier 'diamant' du coffre est invalide..."
        return 1
    fi

    return 0
}


if check
then
    unset -f check
    true
else
    find $GASH_HOME/Chateau/Cave/ -name labyrinthe -type d -print0 | xargs -0 rm -rf
    find $(_coffre) -type f | xargs grep -l "diamant" | xargs rm -f
    unset -f check
    false
fi




