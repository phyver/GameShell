#!/bin/bash

echo $GASH_HOME

mkdir -p "$GASH_HOME/Chateau/Observatoire"
gcc -o "$GASH_HOME/Chateau/Observatoire/merlin" "$mission/merlin.c"

 

