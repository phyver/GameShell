#!/bin/bash

# fichier lu par le shell à chaque démarage de la mission

cd "$GASH_HOME/Chateau/Cave"

D=$(date +%s)
for i in $(seq 3)
do
    S=$(checksum "piece_$i#$D")
    echo "piece_$i#$D $S" > "piece_$i"
done

unset D S i
