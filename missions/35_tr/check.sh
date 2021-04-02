#!/bin/bash

if [ -z "$_SECRET_KEY" ]
then
    echo "Oups, probleme d'initialisation."
    echo "La mision est relancee..."
    false
    return
fi

echo "Quelle est la clé qui fait apparaitre le coffre de Merlin ? "
read -er dcode

if [ "$dcode" = "$_SECRET_KEY" ]
then
    unset dcode _SECRET_KEY
    mkdir -p "$GASH_HOME/Chateau/Cave/Coffre_de_merlin"                       # je met le coffre
    cp "$MISSION_DIR"/recette_secrete "$GASH_HOME/Chateau/Cave/Coffre_de_merlin" # et son contenu (cela ne sert à rien pour la mission, mais si 
    true                                                                    # l'utilisateur à la curiosité d'aller voir, il y aura qqch)
else
    echo "Ce n'est pas la bonne clé.."
    unset dcode _SECRET_KEY
    false
fi

