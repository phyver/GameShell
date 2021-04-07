#!/bin/bash

IN_ENTRANCE=$(CANONICAL_PATH "$(eval_gettext "\$GASH_TMP/in_entrance")")
CASTLE_ENTRANCE=$(CANONICAL_PATH "$(eval_gettext "\$GASH_HOME/Castle/Entrance")")
GASH_HUT=$(CANONICAL_PATH "$(eval_gettext "\$GASH_HOME/Forest/Hut")")
HAY=$(gettext "hay")
GRAVEL=$(gettext "gravel")
DETRITUS=$(gettext "detritus")
ORNEMENT=$(gettext "ornement")

D=$(date +%s)

for i in $(seq -w 5)
do
    S=$(checksum "detritus_$i#$D")
    touch "${CASTLE_ENTRANCE}/${S}_${DETRITUS}"
done

for i in $(seq -w 5)
do
    S=$(checksum "${HAY}_$i#$D")
    touch "${CASTLE_ENTRANCE}/${S}_${HAY}"
done

for i in $(seq -w 5)
do
    S=$(checksum "${GRAVEL}_$i#$D")
    touch "${CASTLE_ENTRANCE}/${S}_${GRAVEL}"
done

for i in $(seq -w 10)
do
    S=$(checksum "${ORNEMENT}_$i#$D")
    touch "${CASTLE_ENTRANCE}/${S}_${ORNEMENT}"
done

command ls "$CASTLE_ENTRANCE" | sort > "$IN_ENTRANCE"

unset D i S cabane
