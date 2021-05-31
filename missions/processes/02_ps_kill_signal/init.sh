#!/bin/bash

_mission_init() {

  local CC
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
    # under BSD, libintl is installed in /usr/local
    $CC -lpthread "$MISSION_DIR/spell.c" -o "$GSH_VAR/$(gettext "spell")" 2>/dev/null ||
    $CC -I/usr/local/include/ -L/usr/local/lib -lintl -lpthread "$MISSION_DIR/spell.c" -o "$GSH_VAR/$(gettext "spell")" 2>/dev/null ||
    { echo "compilation failed" >&2; return 1; }
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
