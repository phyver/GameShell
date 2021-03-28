#!/bin/bash

# fichier lu par le shell à chaque démarrage de la mission

rm -rf "$GASH_HOME/Chateau/Cave/.Long"*Couloir*

coul=".Long $(checksum $RANDOM) Couloir $(checksum $RANDOM)"

mkdir -p "$GASH_HOME/Chateau/Cave/$coul"

echo "$coul" | sha1sum | cut -c 1-40 > "$GASH_TMP/couloir"

unset coul



