#!/bin/bash

_local_check_p() {
    local file=$1
    local path
    path=$(find "$GASH_COFFRE" -name "*$file" -type f)

    if [ -z "$path" ]
    then
        echo "Toutes les pièces ne sont pas dans le coffre !"
        return 1
    fi
    if ! diff -q "$path" "$GASH_TMP/$file" > /dev/null
    then
        echo "La pièce '$file' dans le coffre n'est pas la bonne !"
        return 1
    fi
}

_local_check() {
    local lab
    lab=$(find "$GASH_HOME/Chateau/Cave" -name labyrinthe -type d)
    local nb
    nb=$(find "$lab" -iname "piece_d_or" -type f | wc -l)
    if [ "$nb" -gt 2 ]
    then
        echo "Il y a trop de pièces dans le labyrinthe !!!"
        return 1
    fi
    if [ "$nb" -ne 0 ]
    then
        echo "Il reste des pièces dans le labyrinthe "
        return 1
    fi

    _local_check_p "piece_d_or" && _local_check_p "PieCe_D_Or"
}

if _local_check
then
    unset -f _local_check _local_check_p
    true
else
    unset -f _local_check _local_check_p
    find "$GASH_HOME" -iname piece_d_or -not -iname "*journal*" -print0 | xargs -0 rm -f
    false
fi


