#!/bin/bash

[ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
mkdir -p "$GSH_CHEST"

maze="$(eval_gettext '$GSH_HOME/Garden/Maze')"
rm -rf "$maze"/?*


mkdir -p "$maze"
if ! command -v python3 &> /dev/null
then
    d=$("$GSH_MISSIONS_BIN"/maze1.sh "$maze" 3 1)
else
    d=$("$GSH_MISSIONS_BIN"/maze1.py "$maze" 3 3 1)
fi
echo "$(CHECKSUM "$d")" > "$maze/$d/OOOOO_$(gettext "silver_coin")_OOOOO"
echo "$(CHECKSUM "$d")" > "$GSH_VAR/silver_coin"

unset maze d

