#!/bin/bash

_mission_check() {
  local time_limit=$(( $(date +%s) + 10 ))

  exec 3< "$GSH_VAR/arith.txt"
  local line
  while IFS='' read -response -u 3 line
  do
    local question="$(echo "$line" | cut -d"|" -f1)"
    local result="$(echo "$line" | cut -d"|" -f2)"

    local response
    read -erp "$question" response
    if [ "$time_limit" -le "$(date +%s)" ]
    then
      echo "$(gettext "Too slow! You need to give the answers in less than 10 seconds...")"
      OK=""
      break
    fi

    case "$response" in
      "" | *[!0-9]*)
        echo "$(gettext "That's not even a number!")"
        return 1
        ;;
      *)
        [ "$result" -eq "$response" ] && continue
        echo "$(eval_gettext 'Too bad! The expected answer was $result...')"
        return 1
        ;;
    esac
  done

}

_mission_check
