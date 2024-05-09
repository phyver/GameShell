#!/bin/sh

. gsh_gettext.sh

CODE=$1
STATE=init

trap 'control_c' INT
control_c() {
  if [ "$STATE" = "init" ]
  then
    echo
    echo "$(eval_gettext 'Too soon! You must leave enough time for the magical reaction to start!')"
    exit 1
  else
    echo
    cat "$MISSION_DIR/ascii-art/explosion.txt"
    echo "$(gettext "That's not working, try a different combination...")"
  fi
  exit 1
}


indent=8
width=16
magical_reaction() {
  seconds=$1    # how long to magical_reaction randomly (real time will be between $seconds and $seconds+1
  dud=$2      # should more '.' characters appears as times passes

  now=$(date +%s)
  delay=0
  while [ "$delay"  -le "$seconds" ]
  do
    delay=$(($(date +%s) - now))
    # NOTE: if I put $(RANDOM) inside the $((...)), interrupting the process during
    # the RANDOM execution returns an empty string, and the shell complains about
    # invalid arithmetic expression
    r=$(RANDOM)
    indent=$((indent - 2 + r%5))
    [ "$indent" -lt 0 ] && indent=0
    r=$(RANDOM)
    width=$((width - 2 + r%5))
    [ "$width" -lt 1 ] && width=1
    if [ "$dud" ]
    then
      i=$((delay/2 + 2))
    else
      i=1
    fi
    alpha=$(echo "#%*():_-............." | awk "{print substr(\$0, $i<10?$i:10, 10)}" )
    printf "%*s%s\n" "$indent" '' "$(random_string "$width" "$alpha")" >&2
    sleep 0.1
  done
}

check() {
  [ -f "$GSH_TMP/control-C" ] || exit 255
  n=$(cat "$GSH_TMP/control-C")
  case "$n" in
    "" | *[!0-9]* )
      if [ "$n" = "$CODE" ]
      then
        echo
        echo "$(eval_gettext 'It works! The special incantation is $CODE')"
        cat "$MISSION_DIR/ascii-art/fireworks.txt"
        exit 0
      else
        echo "$CODE" >> "$GSH_TMP/control-C.codes"
      fi
      ;;
    *)
      if [ "$n" -le 0 ]
      then
        # if we've finished, print the solution and save it
        echo "$CODE" > "$GSH_TMP/control-C"
        echo
        echo "$(eval_gettext 'It works! The special incantation is $CODE')"
        cat "$MISSION_DIR/ascii-art/fireworks.txt"
        exit 0
      else
        echo "$CODE" >> "$GSH_TMP/control-C.codes"
        echo "$((n-1))" > "$GSH_TMP/control-C"
      fi
  esac
  STATE="final"
}

init() {
  case "$CODE" in
    "")
      command=$(gettext "Charmiglio")
      echo "$(eval_gettext 'usage: $command CCCC
      where CCCC is a sequence of 4 ASCII letters (a-zA-Z)')"
      exit 1
      ;;

    *[!a-zA-Z]*)
      echo "$(gettext "The incantation can only use ASCII letters.")"
      exit 1
      ;;
    ????)
      :     # 4 letters, OK
      ;;
    *)
      echo "$(gettext "The incantation requires exactly 4 letters.")"
      exit 1
      ;;
  esac

  if grep -qsx "$CODE" "$GSH_TMP/control-C.codes"
  then
    echo "already tried!"
    exit 1
  fi
}


init
magical_reaction 2      # magical reaction for 2 second
check
magical_reaction 600 dud # dud for 10 minutes

echo
echo "$(gettext "That's not working, try a different combination...")"
echo "$(gettext "NOTE: you should interrupt the magical reaction after a few seconds!")"
