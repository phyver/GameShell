#!/bin/bash

mkdir -p "$GASH_HOME/Chateau/Observatoire"
[ -f "$GASH_HOME/Chateau/Observatoire/merlin" ] || gcc -o "$GASH_HOME/Chateau/Observatoire/merlin" "$GASH_MISSIONS"/*_stdout_stderr_redirection/merlin.c

