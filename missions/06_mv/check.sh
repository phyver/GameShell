#!/bin/bash

# TODO: limiter le nombre de commandes pour éviter
# mv truc ..
# cd ..
# mv truc ..
# ....

check() {
    local cave=$GASH_HOME/Chateau/Cave
    local i=$1
    local piece="piece_$i"

    # check that file doesn't exists in cave
    local file=$(find "$cave" -maxdepth 1 -name "piece_$i")
    if [ -f "$file" ]
    then
        echo "La pièce '$piece' est encore dans la cave."
        return 1
    fi

    # check that file exists
    local file=$(find "$GASH_COFFRE" -maxdepth 1 -name "piece_$i")
    if [ ! -f "$file" ]
    then
        echo "La pièce '$piece' n'est pas dans le coffre."
        return 1
    fi

    # check that prefix of first line is piece_$i
    local P=$(cat "$file" | cut -f 1 -d' ')
    if [ "$(echo $P | cut -f1 -d'#')" != "$piece" ]
    then
        echo "Contenu du fichier '$file' invalide."
        return 1
    fi

    # check that suffix of file is the SHA1 of $piece
    local S=$(cat "$file" | cut -f 2 -d' ')
    if [ "$S" != "$(checksum $P)" ]
    then
        echo "Contenu du fichier '$file' invalide."
        return 1
    fi

    return 0
}


if check 1 && check 2 && check 3
then
    unset -f check
    true
else
    unset -f check
    find $GASH_HOME -name "piece_?" -type f | xargs rm -f
    false
fi
