#!/bin/bash

mkdir -p "$GASH_HOME/Chateau/Observatoire"

# certains se débrouillent pour écraser merlin ! Il faut mieux le regénérer,
# même si le fichier existe !
if command -v gcc > /dev/null
then
    gcc -o "$GASH_HOME/Chateau/Observatoire/merlin" "$GASH_MISSIONS"/*_stdout_stderr_redirection/merlin.c
elif command -v python3 > /dev/null
then
    cp "$GASH_MISSIONS"/*_stdout_stderr_redirection/merlin.py "$GASH_HOME/Chateau/Observatoire/merlin"
    chmod 755 "$GASH_HOME/Chateau/Observatoire/merlin"
fi

