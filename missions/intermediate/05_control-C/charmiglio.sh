#!/usr/bin/env sh

. gsh_gettext.sh

control_c_start() {
  [ -f "$GSH_TMP/control-C" ] || exit 255
  n=$(cat "$GSH_TMP/control-C")
  case "$n" in
    "" | *[!0-9]* )
      echo
      echo
      echo "$(eval_gettext 'Found it! The special incantion is $n')"
      ;;
    *)
      echo
      echo
      echo "$(gettext "Don't interrupt me when I'm in a trance!!!")"
      ;;
  esac
  exit 1
}

control_c_end() {
  [ -f "$GSH_TMP/control-C" ] || exit 255
  n=$(cat "$GSH_TMP/control-C")
  case "$n" in
    "" | *[!0-9]* )
      echo
      echo
      echo "$(eval_gettext 'Found it! The special incantion is $n')"
      ;;
    *)
      echo "$((n-1))" > "$GSH_TMP/control-C"
      echo
      echo
      echo "$(gettext "Sorry, I fell asleep... Let's try again.")"
      ;;
    esac
  exit 1
}

mumble() {
  seconds=$1
  now=$(date +%s)

  while [ "$(($(date +%s) - now))" -le "$seconds" ]
  do
    printf "$(gettext "Merlin mumbles ")"  >&2
    random_string "$((8 + $(RANDOM)%42))" | tr "A-Z" " " >&2
    sleep 0.1
  done
}

check() {
  [ -f "$GSH_TMP/control-C" ] || exit 255
  n=$(cat "$GSH_TMP/control-C")
  case "$n" in
    "" | *[!0-9]* )
      # we already know the solution
      echo
      echo "$(eval_gettext 'Found it! The special incantation is $n')"
      exit 0
      ;;
    *)
      if [ "$n" -le 0 ]
      then
        # if we've finished, print the solution and save it
        n=$(random_string 5)
        echo "$n" > "$GSH_TMP/control-C"
        echo
        echo "$(eval_gettext 'Found it! The special incantation is $n')"
        exit 0
      fi
  esac
}

trap 'control_c_start' INT
mumble 2      # mumble for 2 second
check
trap 'control_c_end' INT
mumble 120  # mumble for 2 minutes
echo
echo "$(gettext "Sorry, I fell asleep... Let's try again.")"

echo "$(gettext "NOTE: you need to interrupt Merlin before he wakes up.")"
