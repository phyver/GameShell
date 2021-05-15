#!/usr/bin/env bash

mkdir -p "$(eval_gettext '$GSH_HOME/Castle/Observatory')"

random_key(){
    local ALPHA=ABCDEFGHIJKLMNOPQRSTUVWXYZ
    local i
    for i in $(seq $1)
    do
        echo -n "${ALPHA:$((RANDOM%26)):1}"
    done
}
random_key 200 > "$GSH_VAR/secret_key"

# certains se débrouillent pour écraser merlin ! Il faut mieux le regénérer,
# même si le fichier existe !
cp  "$GSH_MISSIONS_BIN"/merlin.sh "$(eval_gettext '$GSH_HOME/Castle/Observatory')/merlin"
chmod 755 "$(eval_gettext '$GSH_HOME/Castle/Observatory')/merlin"
