#!/bin/bash

[ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
mkdir -p "$GSH_CHEST"

maze="$(eval_gettext '$GSH_HOME/Garden/.Maze')"
rm -rf "$maze"/?*

mkdir -p "$maze"
if ! command -v python3 > /dev/null
then
    d=$("$GSH_MISSIONS_BIN"/maze1.sh "$maze" 10 2)
else
    d=$("$GSH_MISSIONS_BIN"/maze1.py "$maze" 3 10 2)
fi

d1=$(echo "$d" | head -n 1)
d2=$(echo "$d" | head -n 1)
echo "$(checksum "$d1")" > "$maze/$d1/$(gettext "gold_coin")"
echo "$(checksum "$d1")" > "$GSH_VAR/gold_coin"
echo "$(checksum "$d2")" > "$maze/$d2/$(gettext "GolD_CoiN")"
echo "$(checksum "$d2")" > "$GSH_VAR/GolD_CoiN"

unset maze d d1 d2
