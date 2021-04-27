#!/bin/bash

[ -z "$GASH_CHEST" ] && GASH_CHEST="$(eval_gettext '$GASH_HOME/Forest/Cabin/Chest')"
mkdir -p "$GASH_CHEST"

D=$(date +%s)

rm -f "$(eval_gettext '$GASH_HOME/Castle/Cellar')/.$(gettext "coin")_"*

for I in $(seq 3)
do
  C=".$(gettext "coin")_$I"
  S=$(checksum "$C#$D")
  echo "$C#$D $S" > "$(eval_gettext '$GASH_HOME/Castle/Cellar')/${C}_$S"
done

unset DATE D I C S
