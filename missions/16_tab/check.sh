#!/bin/bash

S1=$(basename "$PWD" / | checksum)
S2=$(cat "$GSH_VAR/corridor")

if [ "$S1" = "$S2" ]
then
    unset S1 S2
    true
else
    unset S1 S2
    cd
    rm -rf "$(eval_gettext '$GSH_HOME/Castle/Cellar')"/$(eval_gettext '.Long*Corridor*')
    echo "$(gettext "Pffft... You are back to the beginning, in front of the castle...")"
    false
fi

