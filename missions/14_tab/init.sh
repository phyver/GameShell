#!/bin/bash

# fichier lu par le shell à chaque démarage de la mission

rm -rf $GASH_HOME/Chateau/Cave/.long*couloir*

coul=".Long $(checksum $RANDOM) Couloir $(checksum $RANDOM)"

mkdir -p $GASH_HOME/Chateau/Cave/"$coul"

echo $coul | sha1sum | cut -c 1-40 > $GASH_VAR/couloir

unset coul



