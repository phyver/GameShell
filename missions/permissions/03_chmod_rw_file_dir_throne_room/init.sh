#!/bin/bash

[ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
mkdir -p "$GSH_CHEST"

safe="$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')/$(gettext "Safe")"
mkdir -p "$safe"
chmod 755 "$safe"
chmod 644 "$safe/$(gettext "crown")" 2> /dev/null
k=$(echo -n "000$(($RANDOM % 1000))" | tail -c3)

sed "s/KEY/$k/" "$MISSION_DIR/ascii-art/crown.txt" > "$safe/$(gettext "crown")"

cp "$safe/$(gettext "crown")" "$GSH_VAR"/crown

chmod 000 "$safe/$(gettext "crown")"
chmod 000 "$safe"

unset safe k

