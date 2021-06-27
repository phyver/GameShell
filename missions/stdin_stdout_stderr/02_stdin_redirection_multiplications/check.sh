#!/bin/sh

_mission_check() (
  time_limit=$(( $(date +%s) + 10 ))

  exec 3< "$GSH_TMP/arith.txt"
  while IFS='' read -r line <&3
  do
    question="$(echo "$line" | cut -d"|" -f1)"
    result="$(echo "$line" | cut -d"|" -f2)"

    printf "%s" "$question"
    read -r response
    if [ "$time_limit" -le "$(date +%s)" ]
    then
      echo "$(gettext "Too slow! You need to give the answers in less than 10 seconds...")"
      return 1
    fi

    case "$response" in
      "" | *[!0-9]*)
        echo "$(gettext "That's not even a number!")"
        return 1
        ;;
      *)
        [ "$result" -eq "$response" ] && continue
        echo "$(eval_gettext 'Too bad! The answer was $result...')"
        return 1
        ;;
    esac
  done
  return 0
)

_mission_check
