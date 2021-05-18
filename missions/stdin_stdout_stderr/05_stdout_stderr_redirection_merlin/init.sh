#!/bin/bash

mkdir -p "$(eval_gettext '$GSH_HOME/Castle/Observatory')"

random_string 200 > "$GSH_VAR/secret_key"

# certains se débrouillent pour écraser merlin ! Il faut mieux le regénérer,
# même si le fichier existe !
copy_bin  "$MISSION_DIR"/merlin.sh "$(eval_gettext '$GSH_HOME/Castle/Observatory')/merlin"
chmod 755 "$(eval_gettext '$GSH_HOME/Castle/Observatory')/merlin"
