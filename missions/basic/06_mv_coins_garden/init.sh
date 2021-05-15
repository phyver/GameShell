#!/usr/bin/env bash

[ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
mkdir -p "$GSH_CHEST"

D=$(date +%s)

for I in $(seq 3)
do
  C="$(gettext "coin")_$I"
  touch "$(eval_gettext "\$GSH_HOME/Garden")/$C"
  sign_file "$(eval_gettext "\$GSH_HOME/Garden")/$C"
done

unset DATE D I C S
