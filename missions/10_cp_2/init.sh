#!/bin/bash

[ -z "$GASH_CHEST" ] && GASH_CHEST="$(eval_gettext '$GASH_HOME/Forest/Cabin/Chest')"
mkdir -p "$GASH_CHEST"

ENTRANCE="$(eval_gettext "\$GASH_HOME/Castle/Entrance")"

find "$ENTRANCE" \
        \( -name "*$(gettext "ornament")*" \
        -o -name "*$(gettext "garbage")*" \
        -o -name "*$(gettext "gravel")*" \
        -o -name "*$(gettext "hay")*" \) -print0 | xargs -0 rm -f

find "$GASH_CHEST" \
        \( -name "*$(gettext "ornament")*" \
        -o -name "*$(gettext "garbage")*" \
        -o -name "*$(gettext "gravel")*" \
        -o -name "*$(gettext "hay")*" \) -print0 | xargs -0 rm -f


D=$(date +%s)

for I in $(seq -w 5)
do
  for K in "$(gettext "garbage")" "$(gettext "gravel")" "$(gettext "hay")"
  do
    touch "${ENTRANCE}/${RANDOM}_${K}_${RANDOM}"
  done
done

for I in $(seq -w 10)
do
  K="$(gettext "ornament")"
  touch "${ENTRANCE}/${RANDOM}_${K}_${RANDOM}"
done

ls "$ENTRANCE" | sort > "$GASH_MISSION_DATA/entrance_contents"

unset ENTRANCE D I K S
