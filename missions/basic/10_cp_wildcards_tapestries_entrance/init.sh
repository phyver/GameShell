#!/bin/bash

[ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
mkdir -p "$GSH_CHEST"

ENTRANCE="$(eval_gettext "\$GSH_HOME/Castle/Entrance")"

find "$ENTRANCE" \
        \( -name "*$(gettext "tapestry")*" \
        -o -name "*$(gettext "stag_head")*" \
        -o -name "*$(gettext "suit_of_armour")*" \
        -o -name "*$(gettext "decorative_sword")*" \) -print0 | xargs -0 rm -f

find "$GSH_CHEST" \
        \( -name "*$(gettext "tapestry")*" \
        -o -name "*$(gettext "stag_head")*" \
        -o -name "*$(gettext "suit_of_armour")*" \
        -o -name "*$(gettext "decorative_sword")*" \) -print0 | xargs -0 rm -f


D=$(date +%s)

for I in $(seq -w 5)
do
  for K in "$(gettext "stag_head")" "$(gettext "suit_of_armour")" "$(gettext "decorative_sword")"
  do
    touch "${ENTRANCE}/${RANDOM}_${K}_${RANDOM}"
  done
done

for I in $(seq -w 10)
do
  K="$(gettext "tapestry")"
  touch "${ENTRANCE}/${RANDOM}_${K}_${RANDOM}"
done

ls "$ENTRANCE" | sort > "$GSH_VAR/entrance_contents"

unset ENTRANCE D I K S
