#!/bin/bash

[ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
mkdir -p "$GSH_CHEST"

maze="$(eval_gettext '$GSH_HOME/Garden/Maze')"
rm -rf "$maze"/?*

mkdir -p "$maze"
if ! command -v python3 &> /dev/null
then
    d=$("$GSH_MISSIONS_SBIN"/maze1.sh "$maze" 10 6)
else
    d=$("$GSH_MISSIONS_SBIN"/maze1.py "$maze" 3 10 6)
fi
d1=$(echo "$d" | head -n 1)
K=$RANDOM
sum=$(CHECKSUM "$K $(gettext "ruby")")
echo "$K $(gettext "ruby") $sum" > "$maze/$d1/$K"
echo "$K $(gettext "ruby") $sum" > "$GSH_VAR/ruby"

echo "$d" | sed '1d' | while read d1
do
    K=$RANDOM
    sum=$(CHECKSUM "$K $(gettext "stone")")
    echo "$K $(gettext "stone") $sum" > "$maze/$d1/$K"
done

unset maze d1 K sum d
