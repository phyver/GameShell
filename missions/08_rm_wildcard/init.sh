#!/bin/bash

CELLAR=$(eval_gettext "\$GSH_HOME/Castle/Cellar")
mkdir -p "$CELLAR"
rm -f "$CELLAR"/.??*

for I in $(seq -w 10)
do
  touch "${CELLAR}/.${RANDOM}_${I}_$(gettext "salamander")"
done

for I in $(seq -w 100)
do
  touch "${CELLAR}/.${RANDOM}_${I}_$(gettext "spider")"
done

find "$CELLAR" -maxdepth 1 -name ".*$(gettext "salamander")" | sort | checksum > "$GSH_MISSION_DATA/salamanders"

unset CELLAR D I S
