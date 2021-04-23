#!/bin/bash

office="$(eval_gettext '$GASH_HOME/Castle/Main_building/Library/Merlin_s_office')"
find "$office" -type f -name "$(gettext "grimoire")_*" -print0 | xargs -0 rm -f

for i in $(seq 100)
do
    file="$office/$(gettext "grimoire")_$(checksum $RANDOM)"
    tr -dc A-Za-z </dev/urandom | head -c 100 > "$file"

    if [ $(( RANDOM % 2 )) -eq 0 ]
    then
        chmod -r "$file"
    fi
    [ $((i%5)) -eq 0 ] && echo -n "."
done
echo

bash <<EOS
  cd $office
  command ls $(gettext "grimoire")_* | sort > $GASH_MISSION_DATA/list_grimoires
EOS

unset i file office
