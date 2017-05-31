#!/bin/bash

check() {
    local office="$GASH_HOME/Chateau/Batiment_principal/Bibliotheque/Bureau_de_Merlin"

    # turn history on (off by default for non-interactive shells
    HISTFILE=$GASH_DATA/history

    local pc=$(fc -nl -2 -2 | grep 'grep')

    if [ -z "$pc" ]
    then
        return 1
    fi

    if ! diff -q "$GASH_TMP/liste_grimoires_PQ" <(eval "$pc" |& sort) > /dev/null
    then
        return 1
    else
        return 0
    fi
}


if check
then
    unset -f check
    true
else
    unset -f check
    false
fi
