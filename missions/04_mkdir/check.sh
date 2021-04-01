#!/bin/bash

_local_check() {
    local nb_cabanes
    nb_cabanes=$(find "$GASH_HOME/Foret" -iname cabane -type d | wc -l)
    if [ "$nb_cabanes" -ge 2 ]
    then
        echo "Vous avez construit trop de cabanes dans la forêt !"
        return 1
    fi
    if [ "$nb_cabanes" -lt 1 ]
    then
        echo "Vous n'avez pas construit de cabane dans la forêt !"
        return 1
    fi
    local cabane
    cabane=$(find "$GASH_HOME/Foret" -maxdepth 1 -iname cabane)
    if [ -z "$cabane" ]
    then
        echo "Votre cabane est trop loin dans la forêt..."
        return 1
    fi
    cabane=~/Foret/Cabane
    if [ ! -d "$cabane" ]
    then
        echo "Le répertoire $cabane n'existe pas !"
        return 1
    fi

    local nb_coffres
    nb_coffres=$(find "$cabane" -iname coffre -type d | wc -l)
    if [ "$nb_coffres" -ge 2 ]
    then
        echo "Vous avez construit trop de coffres dans votre cabane !"
        return 1
    fi
    if [ "$nb_coffres" -lt 1 ]
    then
        echo "Vous n'avez pas construit de coffre dans votre cabane !"
        return 1
    fi
    local coffre
    coffre=$(find "$cabane" -maxdepth 1 -iname coffre)
    if [ -z "$coffre" ]
    then
        echo "Votre coffre n'est au bon endroit dans votre cabane."
        return 1
    fi
    coffre=~/Foret/Cabane/Coffre
    if [ ! -d "$coffre" ]
    then
        echo "Le répertoire $coffre n'existe pas !"
        return 1
    fi
    return 0
}

if _local_check
then
    true
else
    find "$GASH_HOME" -iname "*cabane*" -print0 | xargs -0 rm -rf
    find "$GASH_HOME" -iname "*coffre*" -print0 | xargs -0 rm -rf
    cd
    echo "Vous voila de retour au point de départ... Veuillez recommencer la mission."
    false
fi
