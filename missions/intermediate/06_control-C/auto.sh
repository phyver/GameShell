#!/usr/bin/env sh

set -m

  for c in a b c d e f
  do
    eval "$(gettext Charmiglio)" "$c$c$c$c" 2>/dev/null &
    PID=$!
    sleep 4
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


