#!/bin/bash

_local_check() {
    local office
    office="$GASH_HOME/Chateau/Batiment_principal/Bibliotheque/Bureau_de_Merlin"

    if [ ! -f "$office/Tiroir/liste.txt" ]
    then
        echo "Il n'y a pas de fichier 'liste.txt' dans le tiroir du bureau..."
        return 1
    fi

    if ! diff -q <(sort "$office/Tiroir/liste.txt") "$GASH_TMP/liste_grimoires" > /dev/null
    then
        echo "Le contenu du fichier 'liste.txt' n'est pas correct"
        echo "Vous pouvez regarder dans le fichier avec la commande less FICHIER"
        return 1
    fi

    return 0
}


if _local_check
then
    unset -f _local_check
    true
else
    unset -f _local_check
    false
fi
