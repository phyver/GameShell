#!/bin/bash

[ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
mkdir -p "$GSH_CHEST"

D=$(date +%s)

rm -f "$(eval_gettext '$GSH_HOME/Garden')/.$(gettext "coin")_"*

for I in $(seq 3)
do
  C=".$(gettext "coin")_$I"
  S=$(checksum "$C#$D")
  echo "$C#$D $S" > "$(eval_gettext '$GSH_HOME/Garden')/${C}_$S"
done

unset DATE D I C S
