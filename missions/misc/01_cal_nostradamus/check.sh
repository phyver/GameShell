#!/bin/bash

_mission_check() {
  DOW() (
    local dow
    if dow=$(date --date="$1" +%A 2> /dev/null)
    then
      # with gnu "date" command
      echo $dow
      return 0
    elif dow=$(date -jf "%Y-%m-%d" "$1" +%A 2> /dev/null)
    then
      # with freebsd "date" command
      echo $dow
      return 0
    else
      echo "$(gettext "Error: can not get day of week with 'date' command.")" >&2
      return 1
    fi
  )

  local YYYY=$(cut -d"-" -f1 "$GSH_VAR"/date)
  local MM=$(cut -d"-" -f2 "$GSH_VAR"/date)
  local DD=$(cut -d"-" -f3 "$GSH_VAR"/date)

    echo "$(eval_gettext 'What was the day of the week for the $MM-$DD-$YYYY?')"

    local i
    for i in $(seq 7)
    do
      printf "  $i : "
      DOW "2000-05-$i"
    done
    local n
    read -erp "$(gettext "Your answer: ")" n

    case "$n" in
      *[!0-9]* | "")
        echo "$(gettext "That's not even a valid answer!")"
        return 1
        ;;
      *)
        if [ "$n" -gt 7 ] ||  [ "$n" -lt 1 ]
        then
          echo "$(gettext "That's not even a valid answer!")"
          return 1
        fi
        local s=$(DOW "2000-05-$n")
        local t=$(DOW "$YYYY-$MM-$DD")
        unset -f DOW
        [ "$t" = "$s" ]
    esac
}

_mission_check
