#!/bin/sh

_mission_init() ( # subshell to avoid changing directory
  office="$(eval_gettext '$GSH_HOME/Castle/Main_building/Library/Merlin_s_office')"
  find "$office" -type f -name "$(gettext "grimoire")_*" -print0 | xargs -0 rm -f

  RANDOM 200 | for i in $(seq 100)
  do
    read RANDOM
    file="$office/$(gettext "grimoire")_$RANDOM"
    random_string 100 > "$file"

    read RANDOM
    if [ $((RANDOM%2)) -eq 0 ]
    then
      chmod -r "$file"
    fi
    [ $((i%3)) -eq 0 ] && printf "."
  done

  # subshell to avoid changing directory
  cd "$office"
  ls "$(gettext "grimoire")"_* | sort > "$GSH_TMP/inventory_grimoires"

  return 0
)

. progress_bar.sh _mission_init
