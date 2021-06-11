#!/bin/sh

_mission_check() (
  exec 3< "$GSH_TMP/arith.txt"
  while IFS='' read -r line <&3
  do
    question="$(echo "$line" | cut -d"|" -f1)"
    result="$(echo "$line" | cut -d"|" -f2)"

    printf "%s" "$question"
    read -r response
    case "$response" in
      "" | *[!0-9]*)
        echo "$(gettext "That's not even a number!")"
        return 1
        ;;
      *)
        if [ "$result" -ne "$response" ]
        then
          echo "$(eval_gettext 'Too bad! The answer was $result...')"
          return 1
        fi
        ;;
    esac
  done
  return 0
)

_mission_check
