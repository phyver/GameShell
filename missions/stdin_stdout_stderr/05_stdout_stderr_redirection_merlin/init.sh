#!/bin/bash

mkdir -p "$(eval_gettext '$GSH_HOME/Castle/Observatory')"

random_string 200 > "$GSH_VAR/secret_key"

if command -v cc >/dev/null
then
  CC=cc
elif command -v c99 >/dev/null
then
  CC=c99
elif command -v gcc >/dev/null
then
  CC=gcc
elif command -v clang >/dev/null
then
  CC=clang
fi

# certains se débrouillent pour écraser merlin ! Il faut mieux le regénérer,
# même si le fichier existe !
if [ -n "$CC" ]
then
  $CC "$MISSION_DIR/merlin.c" -o "$GSH_VAR/merlin"
  copy_bin  "$GSH_VAR/merlin" "$(eval_gettext '$GSH_HOME/Castle/Observatory')/merlin"
else
  copy_bin  "$MISSION_DIR"/merlin.sh "$(eval_gettext '$GSH_HOME/Castle/Observatory')/merlin"
  chmod 755 "$(eval_gettext '$GSH_HOME/Castle/Observatory')/merlin"
fi
