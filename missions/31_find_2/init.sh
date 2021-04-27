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

t=$(date +%s)

N=10
r1="$((1 + RANDOM%N)),$((1 + RANDOM%N)),$((1 + RANDOM%N))"
r2="$((1 + RANDOM%N)),$((1 + RANDOM%N)),$((1 + RANDOM%N))"
r3="$((1 + RANDOM%N)),$((1 + RANDOM%N)),$((1 + RANDOM%N))"
r4="$((1 + RANDOM%N)),$((1 + RANDOM%N)),$((1 + RANDOM%N))"
r5="$((1 + RANDOM%N)),$((1 + RANDOM%N)),$((1 + RANDOM%N))"
r6="$((1 + RANDOM%N)),$((1 + RANDOM%N)),$((1 + RANDOM%N))"

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
            if [ "$r1" = "$i,$j,$k" ]
            then
                sum=$(checksum "$K.$(gettext "ruby")")
                echo "$(gettext "ruby") $K $sum" > "$lab/$I/$J/$K"
            elif [ "$r2" = "$i,$j,$k" ] || \
                 [ "$r3" = "$i,$j,$k" ] || \
                 [ "$r4" = "$i,$j,$k" ] || \
                 [ "$r5" = "$i,$j,$k" ] || \
                 [ "$r6" = "$i,$j,$k" ]
            then
                sum=$(checksum "$K.$(gettext "stone")")
                echo "$(gettext "stone") $K $sum" > "$lab/$I/$J/$K"
            fi
        done
        echo -n "."
    done
done
echo

unset i j k t coul lab N r1 r2 r3 r4 r5 r6 I J K sum
