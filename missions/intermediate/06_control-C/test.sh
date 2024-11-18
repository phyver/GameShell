#!/usr/bin/env sh

# set -m

do_test() {
  nb=$1
  delay=$2

  for c in $(echo "a b c d e f g h i j" | cut -d' ' -f1-$nb)
  do
    eval "$(gettext Charmiglio) $c$c$c$c &" 2>/dev/null
    PID=$!
    sleep "$delay"
    # NOTE: SIGINT signal doesn't work on non-interactive systems
    kill "$PID" 2> /dev/null

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

do_test 2 4
gsh assert check false < "$GSH_TMP/control-C"

do_test 6 4
gsh assert check true < "$GSH_TMP/control-C"
