#!/bin/bash

D=$(date +%s)

for i in $(seq -w 5)
do
    S=$(checksum "detritus_$i#$D")
    touch $GASH_HOME/Chateau/Entree/${S}_detritus
done

for i in $(seq -w 5)
do
    S=$(checksum "foin_$i#$D")
    touch $GASH_HOME/Chateau/Entree/${S}_foin
done

for i in $(seq -w 5)
do
    S=$(checksum "gravas_$i#$D")
    touch $GASH_HOME/Chateau/Entree/${S}_gravas
done

for i in $(seq -w 10)
do
    S=$(checksum "ornement_$i#$D")
    touch $GASH_HOME/Chateau/Entree/${S}_ornement
done

\ls $GASH_HOME/Chateau/Entree | sort > $GASH_TMP/dans_entree

unset D i S cabane
