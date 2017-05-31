#!/bin/bash

bib=$GASH_HOME/Chateau/Batiment_principal/Bibliotheque/Bureau_de_Merlin
find "$bib" -type f -name "grimoire_*" -print0 | xargs -0 rm -f

for i in $(seq 100)
do
    file=$bib/grimoire_$(checksum $RANDOM)
    tr -dc A-Za-z </dev/urandom | head -c 100 > "$file"

    if [ $(( RANDOM % 2 )) -eq 0 ]
    then
        chmod -r "$file"
    fi
    [ $((i%5)) -eq 0 ] && echo -n "."
done
echo

bash <<EOS
  cd $bib
  grep -il "pq" * 2> /dev/null | sort > $GASH_TMP/liste_grimoires_PQ
EOS

unset i file
