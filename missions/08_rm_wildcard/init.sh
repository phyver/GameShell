#!/bin/bash

# fichier lu par le shell à chaque démarrage de la mission

mkdir -p "$GASH_HOME/Chateau/Cave/.Terrier"
terrier=$GASH_HOME/Chateau/Cave/.Terrier""

D=$(date +%s)

for i in $(seq -w 10)
do
    S=$(checksum "chat_$i#$D")
    touch "$terrier/${S}_CHAT"
done

for i in $(seq -w 100)
do
    S=$(checksum "rat_$i#$D")
    touch "$terrier/${S}_rat"
done

command ls "$terrier" | grep ".*CHAT$" | sort | sha1sum | cut -c 1-40 > "$GASH_TMP/chats"

unset terrier D S i
