#!/bin/bash

coul=$(find $GASH_HOME/Chateau/Cave/ -name ".Long*Couloir*")
if [ -z "$coul" ]
then
    coul=$GASH_HOME/Chateau/Cave/".Long $(checksum $RANDOM) Couloir $(checksum $RANDOM)"
    mkdir -p $GASH_HOME/Chateau/Cave/"$coul"
fi

lab=$coul/labyrinthe

t=$(date +%s)

N=2
r1="$((1 + $RANDOM%$N)),$((1 + $RANDOM%$N)),$((1 + $RANDOM%$N))"

echo -n "génération du labyrinthe : "
for i in $(seq $N)
do
    I=$(checksum $t$i)
    mkdir -p "$lab/$I"
    for j in $(seq $N)
    do
        J=$(checksum $t$i$j)
        mkdir -p "$lab/$I/$J"
        for k in $(seq $N)
        do
            K=$(checksum $t$i$j$k)
            mkdir -p "$lab/$I/$J/$K"

            if [ "$r1" = "$i,$j,$k" ]
            then
                echo "$I $J $K" > "$lab/$I/$J/$K/piece_d_argent"
                echo "$I $J $K" > "$GASH_TMP/argent"
            fi
        done
        echo -n "."
    done
done
echo

unset i j k t coul lab N r1 I J K


