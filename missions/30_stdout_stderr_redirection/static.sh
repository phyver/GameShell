#!/bin/bash

mkdir -p "$GASH_HOME/Chateau/Observatoire"
if ! gcc -o "$GASH_HOME/Chateau/Observatoire/merlin" "$MISSION_DIR"/merlin.c
then
    echo "ERREUR lors de la commande"
    echo 'gcc -o "$GASH_HOME/Chateau/Observatoire/merlin" "$MISSION_DIR"/merlin.c'
    exit
fi
