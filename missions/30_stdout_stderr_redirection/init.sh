#!/bin/bash

mkdir -p "$(eval_gettext '$GSH_HOME/Castle/Observatory')"

# certains se débrouillent pour écraser merlin ! Il faut mieux le regénérer,
# même si le fichier existe !
if command -v gcc > /dev/null
then
    gcc -o "$(eval_gettext '$GSH_HOME/Castle/Observatory')/merlin" "$MISSION_DIR"/merlin.c
elif command -v clang > /dev/null
then
    clang -o "$(eval_gettext '$GSH_HOME/Castle/Observatory')/merlin" "$MISSION_DIR"/merlin.c
elif command -v cc > /dev/null
then
    cc -o "$(eval_gettext '$GSH_HOME/Castle/Observatory')/merlin" "$MISSION_DIR"/merlin.c
elif command -v python3 > /dev/null
then
    cp  "$MISSION_DIR"/merlin.py "$(eval_gettext '$GSH_HOME/Castle/Observatory')/merlin"
    chmod 755 "$(eval_gettext '$GSH_HOME/Castle/Observatory')/merlin"
fi

