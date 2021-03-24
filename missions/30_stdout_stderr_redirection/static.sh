#!/bin/bash

mkdir -p "$GASH_HOME/Chateau/Observatoire"
if ! gcc -o "$GASH_HOME/Chateau/Observatoire/merlin" "$GASH_MISSIONS"/*_stdout_stderr_redirection/merlin.c
then
    echo "ERREUR lors de la commande"
    echo "gcc -o \"$GASH_HOME/Chateau/Observatoire/merlin\" \"$GASH_MISSIONS\"/*_stdout_stderr_redirection/merlin.c"
    exit
fi
