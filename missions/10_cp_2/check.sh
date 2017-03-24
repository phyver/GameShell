#!/bin/bash

# TODO : revoir le check : si on ajoute des fichiers dans la cabane pendant la
# mission, ça va planter...

check () {

    if ! diff -q $GASH_VAR/dans_entree <(\ls $GASH_HOME/Chateau/Entree | sort) > /dev/null
    then
        echo "Vous avez changé le contenu de l'entrée !"
        return 1
    fi

    local cabane=$(_cabane)
    if [ -z "$cabane" ]
    then
        echo "Où est la cabane ???"
        return 1
    fi

    if \ls "$cabane" | grep -Eq "_foin|_gravas|_detritus"
    then
        echo "Je ne voulais que les ornements de l'entrée !"
        return 1
    fi

    if ! diff -q <(grep "_ornement" "$GASH_VAR/dans_entree") <(\ls "$cabane" | sort | grep "_ornement") > /dev/null
    then
        echo "Je voulais tous les ornements de l'entrée !"
        return 1
    fi

}

if check
then
    unset -f check
    rm -f $GASH_VAR/dans_entree
    true
else
    rm -f $GASH_VAR/dans_entree
    find $GASH_HOME/Chateau/Entree/ -name "*ornement" -o -name "*detritus" -o -name "*gravas" -o -name "*foin" | xargs rm -f
    find $(_cabane) -name "*ornement" -o -name "*detritus" -o -name "*gravas" -o -name "*foin" | xargs rm -f
    unset -f check
    false
fi

