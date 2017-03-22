#!/bin/sh

check() {
    local office=$GASH_HOME/Chateau/Batiment_principal/Bibliotheque/Bureau_de_Merlin

    if [ ! -f $bib/liste.txt ]
    then
        echo "Il n'y a pas de fichier 'liste.txt' dans l'armoire de Merlin..."
        return 1
    fi

    if ! diff <(grep -v "liste\.txt" $bib/liste.txt | sort) $GASH_VAR/liste_grimoires > /dev/null
    then
        echo "Le contenu du fichier 'liste.txt' n'est pas correct"
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
