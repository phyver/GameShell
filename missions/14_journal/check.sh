#!/bin/bash

check() {

    local journal="$GASH_COFFRE/journal.txt"
    if [ ! -f "$journal" ]
    then
        echo "Le fichier '$journal' n'existe pas..."
        find $GASH_HOME -iname "*journal*" | xargs rm -f
        return 1
    fi

    if [ ! -s "$journal" ]
    then
        echo "Le fichier '$journal' est vide !"
        find $GASH_HOME -iname "*journal*" | xargs rm -f
        return 1
    fi

    return 0
}

check
