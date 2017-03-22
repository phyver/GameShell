#!/bin/bash

# fichier lu par le shell à chaque démarage de la mission


coul=$(find $GASH_HOME/Chateau/Cave/ -name ".couloir * tres * long *")
if [ -z "$coul" ]
then
    coul=".couloir $(checksum $RANDOM) tres $(checksum $RANDOM) long $(checksum $RANDOM)"
    mkdir -p $GASH_HOME/Chateau/Cave/"$coul"
    coul=$(find $GASH_HOME/Chateau/Cave/ -name ".couloir * tres * long *")
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

# mise à jours du répertoire courant, qui peut être supprimé lors du ménage
case $PWD in
    *labyrinthe*)
        cd "$(find $GASH_HOME/Chateau/Cave/ -type d -name labyrinthe)" &&
            echo "Vous voila téléporté à l'entrée du labyrinthe..."
        ;;
esac

unset i j k t coul lab N r1 r2 I J K


