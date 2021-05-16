#!/usr/bin/env bash

[ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
mkdir -p "$GSH_CHEST"

D=$(date +%s)

rm -f "$(eval_gettext '$GSH_HOME/Garden')/.$(gettext "coin")_"*

for I in $(seq 3)
do
  f=$(eval_gettext '$GSH_HOME/Garden')/.${RANDOM}_$(gettext "coin")_$I
  touch "$f"
  sign_file "$f"
done

unset DATE D I f S
