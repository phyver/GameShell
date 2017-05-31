#!/bin/bash

# pour laisser le temps au générateur de faire des chats
echo -n .
sleep 1
echo -n .
sleep 1
echo .


cat=$(find "$GASH_HOME/Chateau/Cave" -name ".*_chat")

if [ -z "$cat" ]
then
    unset cat
    true
else
    unset cat
    false
fi
