#!/bin/bash

# TODO : revoir le check : si on ajoute des fichiers dans la cabane pendant la
# mission, ça va planter...

check () {

    if ! diff -q $GASH_TMP/dans_entree <(\ls $GASH_HOME/Chateau/Entree | sort) > /dev/null
    then
        echo "Vous avez changé le contenu de l'entrée !"
        return 1
    fi

    if [ -z "$GASH_CABANE" ]
    then
        echo "Où est la cabane ???"
        return 1
    fi

    if \ls "$GASH_CABANE" | grep -Eq "_foin|_gravas|_detritus"
    then
        echo "Je ne voulais que les ornements de l'entrée !"
        return 1
    fi

    if ! diff -q <(grep "_ornement" "$GASH_TMP/dans_entree") <(\ls "$GASH_CABANE" | sort | grep "_ornement") > /dev/null
    then
        echo "Je voulais tous les ornements de l'entrée !"
        return 1
    fi

}

if check
then
    unset -f check
    rm -f $GASH_TMP/dans_entree
    true
else
    rm -f $GASH_TMP/dans_entree
    find $GASH_HOME/Chateau/Entree/ -name "*ornement" -o -name "*detritus" -o -name "*gravas" -o -name "*foin" | xargs rm -f
    find $GASH_CABANE -name "*ornement" -o -name "*detritus" -o -name "*gravas" -o -name "*foin" | xargs rm -f
    unset -f check
    false
fi

