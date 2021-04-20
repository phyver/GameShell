#!/bin/bash

# pour laisser le temps au générateur de faire des chats
echo -n .
sleep 1
echo -n .
sleep 1
echo .


cat=$(find "$(eval_gettext '$GASH_HOME/Castle/Cellar')" -name ".*_$(gettext "cat")")

if [ -z "$cat" ]
then
    unset cat
    true
else
    unset cat
    false
fi
