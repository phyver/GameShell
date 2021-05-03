#!/bin/bash

bib="$(eval_gettext '$GASH_HOME/Castle/Main_building/Library/Merlin_s_office')"
find "$bib" -type f -name "$(gettext "grimoire")_*" -print0 | xargs -0 rm -f

rm -f "$GASH_MISSION_DATA/list_grimoires_RO"
for i in $(seq 100)
do
    file="$bib/$(gettext "grimoire")_$(checksum $RANDOM)"
    tr -dc A-Za-z </dev/urandom | head -c 100 > "$file"

    if [ $(( RANDOM % 2 )) -eq 0 ]
    then
        chmod -r "$file"
        echo "$file" >> "$GASH_MISSION_DATA/list_grimoires_RO"
    fi
    [ $((i%5)) -eq 0 ] && echo -n "."
done
echo

bash <<EOS
  cd $bib
  grep -il "pq" * 2> /dev/null | sort > $GASH_MISSION_DATA/list_grimoires_PQ
EOS

unset i file
