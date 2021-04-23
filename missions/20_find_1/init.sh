#!/bin/bash

corridor="$(find "$(eval_gettext '$GASH_HOME/Castle/Cellar')" -type d -name "$(gettext ".Long*Corridor*")")"
if [ -z "$corridor" ]
then
    r1=$(checksum $RANDOM)
    r2=$(checksum $RANDOM)
    corridor="$(eval_gettext '$GASH_HOME/Castle/Cellar')/$(eval_gettext '.Long $r1 Corridor $r2')"
    mkdir -p "$corridor"
fi

lab="$corridor/$(gettext "maze")"

t=$(date +%s)

N=10
r1="$((1 + RANDOM%N)),$((1 + RANDOM%N)),$((1 + RANDOM%N))"
r2="$((1 + RANDOM%N)),$((1 + RANDOM%N)),$((1 + RANDOM%N))"

echo -n "$(gettext "maze generation:")"
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

unset i j k t corridor lab N r1 r2 I J K


