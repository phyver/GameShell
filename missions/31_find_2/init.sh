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
    r3="$((1 + RANDOM%N)),$((1 + RANDOM%N)),$((1 + RANDOM%N))"
    r4="$((1 + RANDOM%N)),$((1 + RANDOM%N)),$((1 + RANDOM%N))"
    r5="$((1 + RANDOM%N)),$((1 + RANDOM%N)),$((1 + RANDOM%N))"
    r6="$((1 + RANDOM%N)),$((1 + RANDOM%N)),$((1 + RANDOM%N))"

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
                if [ "$r1" = "$i,$j,$k" ]
                then
                    sum=$(checksum "$K.$(gettext "ruby")")
                    echo "$K $(gettext "ruby") $sum" > "$lab/$I/$J/$K"
                    echo "$K $(gettext "ruby") $sum" > "$GASH_MISSION_DATA/ruby"
                elif [ "$r2" = "$i,$j,$k" ] || \
                     [ "$r3" = "$i,$j,$k" ] || \
                     [ "$r4" = "$i,$j,$k" ] || \
                     [ "$r5" = "$i,$j,$k" ] || \
                     [ "$r6" = "$i,$j,$k" ]
                then
                    sum=$(checksum "$K.$(gettext "stone")")
                    echo "$K $(gettext "stone") $sum" > "$lab/$I/$J/$K"
                fi
            done
            echo -n "."
        done
    done
    echo
else
    mkdir -p "$lab"
    d=$(python3 "$MISSION_DIR"/init.py "$lab" 3 10 6)

    d1=$(echo "$d" | head -n 1)
    K=$RANDOM
    sum=$(checksum "$K $(gettext "ruby")")
    echo "$K $(gettext "ruby") $sum" > "$lab/$d1/$K"
    echo "$K $(gettext "ruby") $sum" > "$GASH_MISSION_DATA/ruby"

    echo "$d" | sed '1d' | while read d1
    do
        K=$RANDOM
        sum=$(checksum "$K $(gettext "stone")")
        echo "$$K (gettext "stone") $sum" > "$lab/$d1/$K"
    done

fi

unset i j k t coul lab N r1 r2 r3 r4 r5 r6 I J K sum corridor d d1
