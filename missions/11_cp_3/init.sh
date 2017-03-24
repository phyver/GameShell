#!/bin/bash

# fichier lu par le shell à chaque démarage de la mission

tableau=$(find $GASH_MISSIONS/ -name "tableau" -type f)

cp $tableau $GASH_HOME/Chateau/Donjon/Premier_etage

touch -t 192911211212 $GASH_HOME/Chateau/Donjon/Premier_etage/tableau
stat -c %y $GASH_HOME/Chateau/Donjon/Premier_etage/tableau | sha1sum | cut -c 1-40 > $GASH_TMP/date_tableau

unset tableau
