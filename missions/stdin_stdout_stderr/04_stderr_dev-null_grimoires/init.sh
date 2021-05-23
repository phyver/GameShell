#!/bin/bash

_mission_init() ( #subshell to avoid changing directory
  local bib="$(eval_gettext '$GSH_HOME/Castle/Main_building/Library/Merlin_s_office')"
  find "$bib" -type f -name "$(gettext "grimoire")_*" -print0 | xargs -0 rm -f

  rm -f "$GSH_VAR/list_grimoires_RO"

  local i
  for i in $(seq 100)
  do
    local file="$bib/$(gettext "grimoire")_$(random_string "$((8+RANDOM%24))")"
    random_string $((100 + RANDOM%100)) > "$file"

    if [ $((RANDOM % 2)) -eq 0 ]
    then
      sed-i "s/gsh//gi" "$file"
    else
      local pattern
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
      local n=$((1 + RANDOM%100))
      sed-i "s/\\(.\\{$n\\}\\)/\\1$pattern/" "$file"
    fi

    if [ $((RANDOM % 2)) -eq 0 ]
    then
      chmod -r "$file"
      echo "$file" >> "$GSH_VAR/list_grimoires_RO"
    fi
    [ $((i%10)) -eq 0 ] && printf "."
  done
  printf "\n"

  cd $bib
  grep -il "gsh" * 2> /dev/null | sort > $GSH_VAR/list_grimoires_GSH
)

_mission_init | progress_bar
