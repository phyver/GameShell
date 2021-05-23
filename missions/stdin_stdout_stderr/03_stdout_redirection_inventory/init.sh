#!/bin/bash

_mission_init() {
  local office="$(eval_gettext '$GSH_HOME/Castle/Main_building/Library/Merlin_s_office')"
  find "$office" -type f -name "$(gettext "grimoire")_*" -print0 | xargs -0 rm -f

  local i
  for i in $(seq 100)
  do
    local file="$office/$(gettext "grimoire")_$(checksum $RANDOM)"
    random_string 100 > "$file"

    if [ $(( RANDOM % 2 )) -eq 0 ]
    then
      chmod -r "$file"
    fi
    [ $((i%3)) -eq 0 ] && echo -n "."
  done
  echo

  ( # subshell to avoid changing directory
    cd $office
    ls $(gettext "grimoire")_* | sort > "$GSH_VAR/inventory_grimoires"
  )

}

_mission_init | progress_bar
