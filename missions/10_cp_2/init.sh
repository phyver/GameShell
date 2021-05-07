#!/bin/bash

[ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
mkdir -p "$GSH_CHEST"

ENTRANCE="$(eval_gettext "\$GSH_HOME/Castle/Entrance")"

find "$ENTRANCE" \
        \( -name "*$(gettext "ornament")*" \
        -o -name "*$(gettext "garbage")*" \
        -o -name "*$(gettext "gravel")*" \
        -o -name "*$(gettext "hay")*" \) -print0 | xargs -0 rm -f

find "$GSH_CHEST" \
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

ls "$ENTRANCE" | sort > "$GSH_VAR/entrance_contents"

unset ENTRANCE D I K S
