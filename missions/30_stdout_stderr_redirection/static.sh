#!/bin/bash

mkdir -p "$GASH_HOME/Chateau/Observatoire"
gcc -o "$GASH_HOME/Chateau/Observatoire/merlin" "$GASH_MISSIONS"/*_stdout_stderr_redirection/merlin.c

