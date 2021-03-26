#!/bin/bash

# TODO: limiter le nombre de commandes pour éviter
# mv truc ..
# cd ..
# mv truc ..
# ....

_local_check() {
    local cave=$GASH_HOME/Chateau/Cave
    local i=$1
    local piece="piece_$i"

    # _local_check that file doesn't exists in cave
    local file
    file=$(find "$cave" -maxdepth 1 -name "piece_$i")
    if [ -f "$file" ]
    then
        echo "La pièce '$piece' est encore dans la cave."
        return 1
    fi

    # _local_check that file exists
    local file
    file=$(find "$GASH_COFFRE" -maxdepth 1 -name "piece_$i")
    if [ ! -f "$file" ]
    then
        echo "La pièce '$piece' n'est pas dans le coffre."
        return 1
    fi

    # _local_check that prefix of first line is piece_$i
    local P
    P=$(cut -f 1 -d' ' "$file")
    if [ "$(echo "$P" | cut -f1 -d'#')" != "$piece" ]
    then
        echo "Contenu du fichier '$file' invalide."
        return 1
    fi

    # _local_check that suffix of file is the SHA1 of $piece
    local S
    S=$(cut -f 2 -d' ' "$file")
    if [ "$S" != "$(checksum "$P")" ]
    then
        echo "Contenu du fichier '$file' invalide."
        return 1
    fi

    return 0
}


if _local_check 1 && _local_check 2 && _local_check 3
then
    unset -f _local_check
    true
else
    unset -f _local_check
    find "$GASH_HOME" -name "piece_?" -type f -print0 | xargs -0 rm -f
    find "$cave" -iname "*coffre*" -type f -print0 | xargs -0 rm -f
    find "$cave" -iname "*cabane*" -type f -print0 | xargs -0 rm -f
    false
fi
