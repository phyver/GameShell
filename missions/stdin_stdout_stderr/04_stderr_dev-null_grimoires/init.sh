#!/bin/bash

bib="$(eval_gettext '$GSH_HOME/Castle/Main_building/Library/Merlin_s_office')"
find "$bib" -type f -name "$(gettext "grimoire")_*" -print0 | xargs -0 rm -f

rm -f "$GSH_VAR/list_grimoires_RO"

_init_grimoires () {
  for i in $(seq 100)
  do
    file="$bib/$(gettext "grimoire")_$(CHECKSUM $RANDOM)"
    random_string $((100 + RANDOM%600)) > "$file"

    if [ $(( RANDOM % 2 )) -eq 0 ]
    then
      chmod -r "$file"
      echo "$file" >> "$GSH_VAR/list_grimoires_RO"
    fi
    [ $((i%5)) -eq 0 ] && printf "."
  done
  printf "\n"
}

_init_grimoires | progress_bar

bash <<EOS
  cd $bib
  grep -il "pq" * 2> /dev/null | sort > $GSH_VAR/list_grimoires_PQ
EOS

unset -f _init_grimoires
unset i file bib
