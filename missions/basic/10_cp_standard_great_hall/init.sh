#!/bin/bash

[ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
mkdir -p "$GSH_CHEST"

mission_source "$MISSION_DIR/init0.sh"

great_hall="$(eval_gettext '$GSH_HOME/Castle/Great_hall')"

D=$(date +%s)

for I in $(seq 4)
do
  F="$(gettext "standard")_${I}"
  touch "${great_hall}/${F}"
  sign_file "${great_hall}/${F}"
done

ls "$great_hall" | sort > "$GSH_VAR/great_hall_contents"

unset great_hall D I F S
