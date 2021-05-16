#!/bin/bash

[ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
mkdir -p "$GSH_CHEST"

GREAT_HALL="$(eval_gettext "\$GSH_HOME/Castle/Great_hall")"

mission_source "$MISSION_DIR/init0.sh"

D=$(date +%s)

for I in $(seq -w 10)
do
    f=${GREAT_HALL}/${RANDOM}_$(gettext "tapestry")_$I
    cp "$MISSION_DIR/ascii-art/tapestry-$((RANDOM%5)).txt" "$f"
    sign_file "$f"
done

ls "$GREAT_HALL" | sort > "$GSH_VAR/great_hall_contents"

unset GREAT_HALL D I K S f
