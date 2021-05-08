#!/bin/bash

[ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
mkdir -p "$GSH_CHEST"

ENTRANCE="$(eval_gettext '$GSH_HOME/Castle/Entrance')"

D=$(date +%s)

for I in $(seq 4)
do
  F="$(gettext "standard")_${I}"
  S=$(checksum "${F}#${D}")
  echo "${F}#${D} ${S}" > "${ENTRANCE}/${F}"
done

unset ENTRANCE D I F S
