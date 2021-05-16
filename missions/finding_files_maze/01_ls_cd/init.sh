#!/bin/bash

[ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
mkdir -p "$GSH_CHEST"

maze="$(eval_gettext '$GSH_HOME/Garden/Maze')"
rm -rf "$maze"/?*

mkdir -p "$maze"

if ! command -v python3 &> /dev/null
then
    d=$("$GSH_MISSIONS_BIN"/maze1.sh "$maze" 2 1)
else
    d=$("$GSH_MISSIONS_BIN"/maze1.py "$maze" 3 2 1)
fi

echo "$(CHECKSUM "$d")" > "$maze/$d/$(gettext "copper_coin")"
echo "$(CHECKSUM "$d")" > "$GSH_VAR/copper_coin"

unset maze d


