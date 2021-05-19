#!/bin/bash

_mission_check() {
  exec 3< "$GSH_VAR/arith.txt"
  local line
  while IFS='' read -r -u 3 line
  do
    local question="$(echo "$line" | cut -d"|" -f1)"
    local result="$(echo "$line" | cut -d"|" -f2)"

    local response
    read -erp "$question" response
    case "$response" in
      "" | *[!0-9]*)
        echo "$(gettext "That's not even a number!")"
        return 1
        ;;
      *)
        if [ "$result" -ne "$response" ]
        then
          echo "$(eval_gettext 'Too bad! The expected answer was $result...')"
          return 1
        fi
        ;;
    esac
  done
  return 0
}

_mission_check
