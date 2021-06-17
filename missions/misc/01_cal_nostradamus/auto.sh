#!/bin/sh

_mission_auto() (
  YYYY=$(cut -d"-" -f1 "$GSH_TMP"/date)
  MM=$(cut -d"-" -f2 "$GSH_TMP"/date)
  DD=$(cut -d"-" -f3 "$GSH_TMP"/date)

  DOW() (
    if dow=$(date --date="$1" +%A 2> /dev/null)
    then
      # with gnu "date" command
      echo "$dow"
      return 0
    elif dow=$(date -jf "%Y-%m-%d" "$1" +%A 2> /dev/null)
    then
      # with freebsd "date" command
      echo "$dow"
      return 0
    else
      echo "$(gettext "Error: can not get day of week with 'date' command.")" >&2
      return 1
    fi
  )

  day=$(DOW "$YYYY-$MM-$DD")
  for I in $(seq 7)
  do
    answer=$(DOW "2000-05-$I")
    if [ "$day" = "$answer" ]
    then
      unset -f DOW
      echo "$I"
      return
    fi
  done
)

_mission_auto | gsh check
