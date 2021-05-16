#!/bin/bash

[ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
mkdir -p "$GSH_CHEST"

maze="$(eval_gettext '$GSH_HOME/Garden/Maze')"
rm -rf "$maze"/?*

mkdir -p "$maze"

if ! command -v python3 &> /dev/null
then
    f=$("$GSH_MISSIONS_BIN"/maze2.sh "$maze" 10 1 "$(gettext "stone")")
else
    f=$("$GSH_MISSIONS_BIN"/maze2.py "$maze" 3 10 1 "$(gettext "stone")")
fi
K=$(basename "$f")
sum=$(CHECKSUM "$K $(gettext "diamond")")
echo "$K $(gettext "diamond") $sum" > "$maze/$f"
echo "$K $(gettext "diamond") $sum" > "$GSH_VAR/diamond"

unset maze K sum
