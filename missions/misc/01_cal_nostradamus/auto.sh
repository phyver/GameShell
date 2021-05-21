#!/bin/bash

_mission_auto() {
  local YYYY=$(cut -d"-" -f1 "$GSH_VAR"/date)
  local MM=$(cut -d"-" -f2 "$GSH_VAR"/date)
  local DD=$(cut -d"-" -f3 "$GSH_VAR"/date)

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

  local day=$(DOW "$YYYY-$MM-$DD")
  local I
  for I in $(seq 7)
  do
    local answer=$(DOW "2000-05-$I")
    if [ "$day" = "$answer" ]
    then
      unset -f DOW
      gsh check < <(echo "$I")
      return
    fi
  done
}

_mission_auto
