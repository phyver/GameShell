#!/bin/bash

# fichier lu par le shell à chaque démarage de la mission

rm -rf $GASH_HOME/Chateau/Cave/.couloir\ *\ tres\ *\ long\ *

long_name=".couloir $(checksum $RANDOM) tres $(checksum $RANDOM) long $(checksum $RANDOM)"

mkdir -p $GASH_HOME/Chateau/Cave/"$long_name"

echo $long_name | sha1sum | cut -c 1-40 > $GASH_VAR/couloir

unset long_name



