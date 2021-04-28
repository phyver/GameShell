#!/bin/bash

[ -z "$GASH_CHEST" ] && GASH_CHEST="$(eval_gettext '$GASH_HOME/Forest/Cabin/Chest')"
mkdir -p "$GASH_CHEST"

ENTRANCE="$(eval_gettext '$GASH_HOME/Castle/Entrance')"

D=$(date +%s)

for I in $(seq 4)
do
  F="$(gettext "standard")_${I}"
  S=$(checksum "${F}#${D}")
  echo "${F}#${D} ${S}" > "${ENTRANCE}/${F}"
done

unset ENTRANCE D I F S
