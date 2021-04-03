#!/bin/bash


goal=$(CANONICAL_PATH "$GASH_HOME/$(gettext -s "Path to the top of the donjon")")
current=$(CANONICAL_PATH "$PWD")

if [ "$goal" = "$current" ]
then
    unset goal current
    true
else
    gettext -s "Failure message"
    cd "$GASH_HOME"
    unset goal current
    false
fi

