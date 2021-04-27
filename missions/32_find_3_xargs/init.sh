#!/bin/bash

[ -z "$GASH_CHEST" ] && GASH_CHEST="$(eval_gettext '$GASH_HOME/Forest/Cabin/Chest')"
mkdir -p "$GASH_CHEST"

corridor="$(find "$(eval_gettext '$GASH_HOME/Castle/Cellar')" -type d -name "$(gettext ".Long*Corridor*")")"
if [ -z "$corridor" ]
then
    r1=$(checksum $RANDOM)
    r2=$(checksum $RANDOM)
    corridor="$(eval_gettext '$GASH_HOME/Castle/Cellar')/$(eval_gettext '.Long $r1 Corridor $r2')"
    mkdir -p "$corridor"
fi

lab="$corridor/$(gettext "maze")"

if ! command -v python3 > /dev/null
then
    echo -n "$(gettext "maze generation:")"
    t=$(date +%s)

    N=10
    r1="$((1 + RANDOM%N)),$((1 + RANDOM%N)),$((1 + RANDOM%N))"

    for i in $(seq $N)
    do
        I=$(checksum "$t$i")
        mkdir -p "$lab/$I"
        for j in $(seq $N)
        do
            J=$(checksum "$t$i$j")
            mkdir -p "$lab/$I/$J"
            for k in $(seq $N)
            do
                K="$t$i$j$k"
                if [ "$r1" = "$i,$j,$k" ]
                then
                    sum=$(checksum "$K $(gettext "diamond")")
                    echo "$K $(gettext "diamond") $sum" > "$lab/$I/$J/$K"
                    echo "$K $(gettext "diamond") $sum" > "$GASH_MISSION_DATA/diamond"
                else
                    sum=$(checksum "$K $(gettext "stone")")
                    echo "$K $(gettext "stone") $K $sum" > "$lab/$I/$J/$K"
                fi
            done
            echo -n "."
        done
    done
    echo
else
    mkdir -p "$lab"
    f=$(python3 "$MISSION_DIR"/init.py "$lab" 3 10 1)
    K=$(basename "$f")
    sum=$(checksum "$K $(gettext "diamond")")
    echo "$K $(gettext "diamond") $sum" > "$lab/$f"
    echo "$K $(gettext "diamond") $sum" > "$GASH_MISSION_DATA/diamond"
fi

unset i j k t corridor lab N r1 r2 I J K f sum
