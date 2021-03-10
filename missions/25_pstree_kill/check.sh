#!/bin/bash

# pour laisser le temps au générateur de faire des chats
echo -n .
sleep 1
echo -n .
sleep 1
echo .

#TODO : il faut aussi vérifier que les fromages sont encore là !!!
cat=$(find "$GASH_HOME/Chateau/Cave" -name ".*_chat")
nbp=$(ps ax | grep "chat.sh" | wc -l)

if [ -z "$cat" ] && [ "$nbp" -eq 4 ]
then
    unset cat nbp
    true
else
    unset cat nbp
    false
fi
