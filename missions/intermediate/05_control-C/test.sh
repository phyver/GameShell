#!/usr/bin/env sh

set -m

do_test() {
  nb=$1
  delay=$2

  for _ in $(seq "$nb")
  do
    eval "$(gettext charmiglio)" 2>/dev/null &
    PID=$!
    sleep "$delay"
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
}

do_test 10 0.3
gsh assert check false < "$GSH_TMP/control-C"

do_test 3 3
gsh assert check false < "$GSH_TMP/control-C"

do_test 6 3
gsh assert check true < "$GSH_TMP/control-C"
