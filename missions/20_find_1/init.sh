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
    r2="$((1 + RANDOM%N)),$((1 + RANDOM%N)),$((1 + RANDOM%N))"

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
                K=$(checksum "$t$i$j$k")
                mkdir -p "$lab/$I/$J/$K"

                if [ "$r1" = "$i,$j,$k" ]
                then
                    echo "$I $J $K" > "$lab/$I/$J/$K/$(gettext "gold_coin")"
                    echo "$I $J $K" > "$GASH_MISSION_DATA/$(gettext "gold_coin")"
                elif [ "$r2" = "$i,$j,$k" ]
                then
                    echo "$I $J $K" > "$lab/$I/$J/$K/$(gettext "GolD_CoiN")"
                    echo "$I $J $K" > "$GASH_MISSION_DATA/$(gettext "GolD_CoiN")"
                fi
            done
            echo -n "."
        done
    done
    echo
else
    mkdir -p "$lab"
    d=$(python3 "$MISSION_DIR"/init.py "$lab" 3 10 2)
    d1=$(echo "$d" | head -n 1)
    d2=$(echo "$d" | head -n 1)
    echo "$(checksum "$d1")" > "$lab/$d1/$(gettext "gold_coin")"
    echo "$(checksum "$d1")" > "$GASH_MISSION_DATA/gold_coin"
    echo "$(checksum "$d2")" > "$lab/$d2/$(gettext "GolD_CoiN")"
    echo "$(checksum "$d2")" > "$GASH_MISSION_DATA/GolD_CoiN"
fi

unset i j k t corridor lab N r1 r2 I J K d d1 d2


