#!/bin/bash

coul=$(find "$GASH_HOME/Chateau/Cave/" -name ".Long*Couloir*")
if [ -z "$coul" ]
then
    coul=$GASH_HOME/Chateau/Cave/".Long $(checksum $RANDOM) Couloir $(checksum $RANDOM)"
    mkdir -p "$GASH_HOME/Chateau/Cave/$coul"
fi

lab=$coul/labyrinthe

t=$(date +%s)

N=10
r1="$((1 + RANDOM%N)),$((1 + RANDOM%N)),$((1 + RANDOM%N))"
r2="$((1 + RANDOM%N)),$((1 + RANDOM%N)),$((1 + RANDOM%N))"
r3="$((1 + RANDOM%N)),$((1 + RANDOM%N)),$((1 + RANDOM%N))"
r4="$((1 + RANDOM%N)),$((1 + RANDOM%N)),$((1 + RANDOM%N))"
r5="$((1 + RANDOM%N)),$((1 + RANDOM%N)),$((1 + RANDOM%N))"
r6="$((1 + RANDOM%N)),$((1 + RANDOM%N)),$((1 + RANDOM%N))"

echo -n "génération du labyrinthe : "
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
                sum=$(checksum "$K.rubis")
                echo "rubis $K $sum" > "$lab/$I/$J/$K"
            elif [ "$r2" = "$i,$j,$k" ] || \
                 [ "$r3" = "$i,$j,$k" ] || \
                 [ "$r4" = "$i,$j,$k" ] || \
                 [ "$r5" = "$i,$j,$k" ] || \
                 [ "$r6" = "$i,$j,$k" ]
            then
                sum=$(checksum "$K.caillou")
                echo "caillou $K $sum" > "$lab/$I/$J/$K"
            fi
        done
        echo -n "."
    done
done
echo

unset i j k t coul lab N r1 r2 r3 r4 r5 r6 I J K sum


