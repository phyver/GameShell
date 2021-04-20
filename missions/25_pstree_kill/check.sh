#!/bin/bash

# pour laisser le temps au générateur de faire des chats
echo -n .
sleep 1
echo -n .
sleep 1
echo .

#TODO : il faudrait aussi vérifier que les fromages sont encore là !!!
cat=$(find "$(eval_gettext '$GASH_HOME/Castle/Cellar')" -name ".*_$(gettext "cat")")
nbp=$(ps ax | grep "generator" | wc -l)

if [ -z "$cat" ] && [ "$nbp" -eq 4 ]
then
    unset cat nbp
    true
else
    unset cat nbp
    false
fi
