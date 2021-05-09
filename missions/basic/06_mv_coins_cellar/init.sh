#!/bin/bash

[ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
mkdir -p "$GSH_CHEST"

D=$(date +%s)

for I in $(seq 3)
do
  C="$(gettext "coin")_$I"
  S=$(checksum "$C#$D")
  echo "$C#$D $S" > "$(eval_gettext "\$GSH_HOME/Castle/Cellar")/$C"
done

unset DATE D I C S
