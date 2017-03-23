#!/bin/sh

check() {
    local office=$GASH_HOME/Chateau/Batiment_principal/Bibliotheque/Bureau_de_Merlin

    if [ ! -f $bib/Tiroir/liste.txt ]
    then
        echo "Il n'y a pas de fichier 'liste.txt' dans le tiroir du bureau..."
        return 1
    fi

    if ! diff <(sort $bib/Tiroir/liste.txt) $GASH_VAR/liste_grimoires > /dev/null
    then
        echo "Le contenu du fichier 'liste.txt' n'est pas correct"
        echo "Vous pouvez regarder dans le fichier avec la commande ``less FICHIER``."
        return 1
    fi

    return 0
}


if check
then
    unset -f check
    true
else
    unset -f check
    false
fi
