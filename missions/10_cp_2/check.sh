#!/bin/bash

# TODO : use checksum instead of plain text files for checking???

check () {
    ls $GASH_HOME/Chateau/Entree | sort > $GASH_VAR/dans_entree
    if ! diff $GASH_VAR/dans_entree $GASH_VAR/dans_entree_all > /dev/null
    then
        echo "Vous avez changé le contenu de l'entrée !"
        return 1
    fi

    local cabane=$(_cabane)
    ls $cabane | sort > $GASH_VAR/dans_cabane
    grep "_ornement$" $GASH_VAR/dans_entree_all > $GASH_VAR/dans_entree_cabane
    cat $GASH_VAR/dans_entree_cabane $GASH_VAR/dans_cabane_all | sort > $GASH_VAR/dans_cabane_ok

    if ! diff $GASH_VAR/dans_cabane $GASH_VAR/dans_cabane_ok > /dev/null
    then
        echo "Je ne voulais que les ornements et tous les ornements de l'entrée !"
        return 1
    fi

    rm -f $GASH_VAR/{dans_entree,dans_entree_cabane,dans_cabane}
}

if check
then
    unset -f check
    true
else
    find $GASH_HOME/Chateau/Entree/ -name "*ornement" -name "*detritus" -name "*gravas" -name "*foin" | xargs rm -f
    find $(_cabane) -name "*ornement" -name "*detritus" -name "*gravas" -name "*foin" | xargs rm -f
    unset -f check
    false
fi

