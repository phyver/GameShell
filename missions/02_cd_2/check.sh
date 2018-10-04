#!/bin/bash

goal=$(CANNONICAL_PATH "$GASH_HOME/Chateau/Cave")
current=$(CANNONICAL_PATH "$PWD")

if [ "$goal" = "$current" ]
then
    unset goal current
    true
else
    echo "Vous n'êtes pas dans la cave..."
    unset goal current
    false
fi

