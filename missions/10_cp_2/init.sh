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

ls $GASH_HOME/Chateau/Entree | sort > $GASH_VAR/dans_entree_all

cabane=$(find $GASH_HOME/Foret/ -iname "cabane" -type d)
ls $cabane | sort > $GASH_VAR/dans_cabane_all

unset D i S cabane
