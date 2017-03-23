#!/bin/bash

check_p() {
    local coffre=$(_coffre)
    local file=$1
    local path=$(find $coffre -name "*$file" -type f)

    if [ -z "$path" ]
    then
        echo "Toutes les pièces ne sont pas dans le coffre !"
        return 1
    fi
    if ! diff -q "$path" "$GASH_VAR/$file" > /dev/null
    then
        echo "La pièce '$file' dans le coffre n'est pas la bonne !"
        return 1
    fi
}

check() {
    local lab=$(find $GASH_HOME/Chateau/Cave -name labyrinthe -type d)
    local nb=$(find "$lab" -iname "piece_d_or" -type f | wc -l)
    if [ $nb -gt 2 ]
    then
        echo "Il y a trop de pièces dans le labyrinthe !!!"
        return 1
    fi
    if [ $nb -ne 0 ]
    then
        echo "Il reste des pièces dans le labyrinthe "
        return 1
    fi

    check_p "piece_d_or" && check_p "Piece_D_Or"
}

if check
then
    unset -f check check_p
    true
else
    unset -f check check_p
    false
fi


