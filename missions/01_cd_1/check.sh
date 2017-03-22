#!/bin/bash

goal=$(readlink -f $GASH_HOME/Chateau/Donjon/Premier_etage/Deuxieme_etage/Haut_donjon)
current=$(pwd | xargs readlink -f)

if [ $goal = $current ]
then
    unset goal current
    true
else
    echo "Vous n'êtes pas en haut du donjon !"
    unset goal current
    false
fi

