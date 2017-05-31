#!/bin/bash

# fichier lu par le shell à chaque démarrage de la mission

D=$(date +%s)
for i in $(seq 4)
do
    S=$(checksum "etendard_$i#$D")
    echo "etendard_$i#$D $S" > "$GASH_HOME/Chateau/Entree/etendard_$i"
done
unset D i S
