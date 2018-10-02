#!/bin/bash


goal=$($READLINK -f "$GASH_HOME/Chateau/Donjon/Premier_etage/Deuxieme_etage/Haut_donjon")
current=$($READLINK -f "$PWD")

if [ "$goal" = "$current" ]
then
    unset goal current
    true
else
    echo "Vous n'êtes pas en haut du donjon !"
    echo "Vous allez recommencer la mission au point de départ."
    cd "$GASH_HOME"
    unset goal current
    false
fi

