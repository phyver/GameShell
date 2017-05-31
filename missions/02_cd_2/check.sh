#!/bin/bash

goal=$(readlink -f "$GASH_HOME/Chateau/Cave")
current=$(pwd | xargs readlink -f)

if [ "$goal" = "$current" ]
then
    unset goal current
    true
else
    echo "Vous n'êtes pas dans la cave..."
    unset goal current
    false
fi

