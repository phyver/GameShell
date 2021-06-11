#!/bin/sh

filename=$(head -n1 "$GSH_TMP/painting")

cp "$(eval_gettext '$GSH_HOME/Castle/Main_tower/First_floor')/$filename" "$GSH_CHEST"

gsh check

unset filename
