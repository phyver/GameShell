#!/bin/bash

check() {
    local nb_cabanes=$(find $GASH_HOME/Foret -iname cabane -type d | wc -l)
    if [ $nb_cabanes -ge 2 ]
    then
        echo "Vous avez construit trops de cabanes dans la forêt !"
        return 1
    fi
    if [ $nb_cabanes -lt 1 ]
    then
        echo "Vous n'avez pas construit de cabane dans la forêt !"
        return 1
    fi
    local cabane=$(find $GASH_HOME/Foret -maxdepth 1 -iname cabane)
    if [ -z "$cabane" ]
    then
        echo "Votre cabane est trop loin dans la forêt..."
        return 1
    fi
    local nb_coffres=$(find $cabane -iname coffre -type d | wc -l)
    if [ $nb_coffres -ge 2 ]
    then
        echo "Vous avez construit trops de coffres dans votre cabane !"
        return 1
    fi
    if [ $nb_coffres -lt 1 ]
    then
        echo "Vous n'avez pas construit de coffre dans votre cabane !"
        return 1
    fi
    local coffre=$(find $cabane -maxdepth 1 -iname coffre)
    if [ -z "$coffre" ]
    then
        echo "Votre coffre n'est au bon endroit dans votre cabane."
        return 1
    fi
    return 0
}

if check
then
    true
else
    find $GASH_HOME/ -iname "*cabane*" | xargs rm -rf
    find $GASH_HOME/ -iname "*coffre*" | xargs rm -rf
    cd
    echo "Vous voila revenu au point de départ... Veuillez recommencer la mission."
    false
fi
