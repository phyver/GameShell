#!/bin/bash

coul=$(find $GASH_HOME/Chateau/Cave/ -name ".Long*Couloir*")
if [ -z "$coul" ]
then
    coul=$GASH_HOME/Chateau/Cave/".Long $(checksum $RANDOM) Couloir $(checksum $RANDOM)"
    mkdir -p $GASH_HOME/Chateau/Cave/"$coul"
fi

lab=$coul/labyrinthe

t=$(date +%s)

N=10
r1="$((1 + $RANDOM%$N)),$((1 + $RANDOM%$N)),$((1 + $RANDOM%$N))"
r2="$((1 + $RANDOM%$N)),$((1 + $RANDOM%$N)),$((1 + $RANDOM%$N))"

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
            K=$(echo $t$i$j$k)
            if [ "$r1" = "$i,$j,$k" ]
            then
                sum=$(checksum "$K.diamant")
                echo "diamant $K $sum" > "$lab/$I/$J/$K"
            else
                sum=$(checksum "$K.cailloux")
                echo "cailloux $K $sum" > "$lab/$I/$J/$K"
            fi
        done
        echo -n "."
    done
done
echo

unset i j k t coul lab N r1 r2 I J K


