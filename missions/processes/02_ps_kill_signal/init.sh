#!/bin/bash

_mission_init() {

  if command -v c99 >/dev/null
  then
    CC=c99
  elif command -v cc >/dev/null
  then
    CC=cc
  elif command -v gcc >/dev/null
  then
    CC=gcc
  elif command -v clang >/dev/null
  then
    CC=clang
  elif ! [ -e "$MISSION_DIR/deps.sh" ]
  then
    # FIXME
    echo "missing dummy mission!"
    return 1
    mission_source "$MISSION_DIR/deps.sh" || return 1
  fi

  if [ -n "$CC" ]
  then
    $CC -lpthread "$MISSION_DIR/spell.c" -o "$GSH_VAR/$(gettext "spell")" || return 1
    unset CC
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
  TEXTDOMAIN=$TEXTDOMAIN "$GSH_VAR/$(gettext "spell")" &
  echo $! > "$GSH_VAR"/spell.pids
  disown
  return 0
}

_mission_init
