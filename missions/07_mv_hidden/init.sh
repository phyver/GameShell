#!/bin/bash

# fichier lu par le shell à chaque démarage de la mission

cd $GASH_HOME/Chateau/Cave

D=$(date +%s)
find $GASH_HOME -name ".piece_*_?" -type f | xargs rm -f

for i in $(seq 3)
do
    S=$(checksum "piece_$i#$D")
    echo "piece_$i#$D $S" > .piece_${S}_$i
done
unset D S
