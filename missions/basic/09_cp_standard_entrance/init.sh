#!/bin/bash

[ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
mkdir -p "$GSH_CHEST"

mission_source "$MISSION_DIR/init0.sh"

entrance="$(eval_gettext '$GSH_HOME/Castle/Entrance')"

D=$(date +%s)

for I in $(seq 3)
do
  F="$(gettext "standard")_${I}"
  touch "${entrance}/${F}"
  sign_file "${entrance}/${F}"
done

ls "$entrance" | sort > "$GSH_VAR/entrance_contents"

unset entrance D I F S
