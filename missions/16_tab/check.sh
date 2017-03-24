#!/bin/bash

S1=$(basename "$PWD" / | sha1sum | cut -c 1-40)
S2=$(cat $GASH_VAR/couloir)

if [ "$S1" = "$S2" ]
then
    unset S1 S2
    true
else
    unset S1 S2
    cd
    echo "Vous êtes téléporté au point de départ !"
    false
fi

