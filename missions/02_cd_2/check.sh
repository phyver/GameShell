#!/bin/bash

goal=$($READLINK -f "$GASH_HOME/Chateau/Cave")
current=$($READLINK -f "$PWD")

if [ "$goal" = "$current" ]
then
    unset goal current
    true
else
    echo "Vous n'êtes pas dans la cave..."
    unset goal current
    false
fi

