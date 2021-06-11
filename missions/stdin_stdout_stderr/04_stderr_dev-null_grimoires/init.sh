#!/bin/sh

_mission_init() ( #subshell to avoid changing directory
  bib="$(eval_gettext '$GSH_HOME/Castle/Main_building/Library/Merlin_s_office')"
  find "$bib" -type f -name "$(gettext "grimoire")_*" -print0 | xargs -0 rm -f

  rm -f "$GSH_TMP/list_grimoires_RO"

  RANDOM 600 | for i in $(seq 100)
  do
    read RANDOM
    file="$bib/$(gettext "grimoire")_$(random_string "$((8+RANDOM%24))")"
    read RANDOM
    random_string $((100 + RANDOM%100)) > "$file"

    read RANDOM
    if [ $((RANDOM % 2)) -eq 0 ]
    then
      # note: case insensitive matching isn't POSIX!
      sed-i "s/[gG][sS][hH]//g" "$file"
    else
      read RANDOM
      case "$((RANDOM % 8))" in
        0) pattern=gsh ;;
        1) pattern=gsH ;;
        2) pattern=gSh ;;
        3) pattern=gSH ;;
        4) pattern=Gsh ;;
        5) pattern=GsH ;;
        6) pattern=GSh ;;
        7) pattern=GSH ;;
      esac
      read RANDOM
      n=$((1 + RANDOM%100))
      sed-i "s/\\(.\\{$n\\}\\)/\\1$pattern/" "$file"
    fi

    read RANDOM
    if [ $((RANDOM % 2)) -eq 0 ]
    then
      chmod -r "$file"
      echo "$file" >> "$GSH_TMP/list_grimoires_RO"
    fi
    [ $((i%10)) -eq 0 ] && printf "."
  done
  printf '\n'

  cd "$bib"
  grep -il -- "gsh" * 2> /dev/null | sort > "$GSH_TMP/list_grimoires_GSH"
)

. progress_bar.sh _mission_init
