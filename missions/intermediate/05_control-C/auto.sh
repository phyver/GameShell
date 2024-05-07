#!/usr/bin/env sh

set -m

for _ in $(seq 6)
do
  eval "$(gettext charmiglio)" 2>/dev/null &
  PID=$!
  sleep 3
  kill -s INT "-$PID" 2> /dev/null

  case "$(cat "$GSH_TMP/control-C")" in
    *[!0-9]*)
      break
      ;;
    *)
      :
      ;;
  esac
done

gsh check < "$GSH_TMP/control-C"


