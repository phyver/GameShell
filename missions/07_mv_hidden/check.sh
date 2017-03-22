#!/bin/bash


check() {
    local coffre=$(_coffre)
    local cave=$GASH_HOME/Chateau/Cave
    local i=$1
    local piece="piece_$i"

    # check that file doesn't exists in cave
    local file=$(find "$cave" -maxdepth 1 -name ".piece_*_$i")
    if [ -f "$file" ]
    then
        echo "La pièce '$(basename $file)' est encore dans la cave."
        return 1
    fi

    # check that file exists
    local file=$(find "$coffre" -maxdepth 1 -name ".piece_*_$i")
    if [ ! -f "$file" ]
    then
        echo "La pièce '$(basename $file)' n'est pas dans le coffre."
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

    # check that SHA1 is also in the filename
    if [ "$S" != "$(echo $file | cut -f 2 -d '_')" ]
    then
        echo "Nom du fichier '$file' invalide."
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
    find $GASH_HOME -name ".piece_*_?" -type f | xargs rm -f
    false
fi
