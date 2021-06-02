#!/bin/bash

_mission_init() {

  local CC
  if command -v gcc >/dev/null
  then
    if [ "$GSH_MODE" = DEBUG ]
    then
      CC="gcc -std=c99 -Wall -Wextra -pedantic"
    else
      CC=gcc
    fi
    echo "CC=$CC"
  elif command -v clang >/dev/null
  then
    if [ "$GSH_MODE" = DEBUG ]
    then
      CC="clang -std=c99 -Wall -Wextra -pedantic"
    else
      CC=clang
    fi
    echo "CC=$CC"
  elif command -v c99 >/dev/null
  then
    CC=c99
    echo "CC=$CC"
  elif command -v cc >/dev/null
  then
    CC=cc
    echo "CC=$CC"
  elif ! [ -e "$MISSION_DIR/deps.sh" ]
  then
    # FIXME
    echo "missing dummy mission!"
    return 1
    mission_source "$MISSION_DIR/deps.sh" || return 1
  fi

  if [ -n "$CC" ]
  then
    $CC "$MISSION_DIR/spell.c" -o "$GSH_VAR/$(gettext "spell")" || return 1
  else
    local PYTHON_PATH
    if PYTHON_PATH=$(command -v python3)
    then
      { echo "#!$PYTHON_PATH" ; sed "1d" "$MISSION_DIR/spell.py" ; } > "$GSH_VAR/$(gettext "spell")"
      else
        cp "$MISSION_DIR/spell.sh" "$GSH_VAR/$(gettext "spell")"
    fi
    chmod 755 "$GSH_VAR/$(gettext "spell")"
  fi
  "$GSH_VAR/$(gettext "spell")" &
  echo $! > "$GSH_VAR"/spell.pid
  disown
  return 0
}

_mission_init
