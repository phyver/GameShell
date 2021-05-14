#!/bin/bash

[ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
mkdir -p "$GSH_CHEST"

ENTRANCE="$(eval_gettext "\$GSH_HOME/Castle/Entrance")"

mission_source "$MISSION_DIR/init0.sh"

D=$(date +%s)

for I in $(seq -w 10)
do
    if [ $((i%2)) -eq 0 ]
    then
        f=${ENTRANCE}/${RANDOM}_$(gettext "tapestry")
    else
        f=${ENTRANCE}/$(gettext "tapestry")_$RANDOM
    fi
    cp "$MISSION_DIR/ascii-art/tapestry-$((RANDOM%5)).txt" "$f"
    sign_file "$f"
done

ls "$ENTRANCE" | sort > "$GSH_VAR/entrance_contents"

unset ENTRANCE D I K S f
