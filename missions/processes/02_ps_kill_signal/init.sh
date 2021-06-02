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
  elif command -v clang >/dev/null
  then
    if [ "$GSH_MODE" = DEBUG ]
    then
      CC="clang -std=c99 -Wall -Wextra -pedantic"
    else
      CC=clang
    fi
  elif command -v c99 >/dev/null
  then
    CC=c99
  elif command -v cc >/dev/null
  then
    CC=cc
  elif ! [ -e "$MISSION_DIR/deps.sh" ]
  then
    # FIXME
    echo "missing dummy mission!"
    return 1
    mission_source "$MISSION_DIR/deps.sh" || return 1
  fi

  if [ -n "$CC" ]
  then

    (
      # in debug mode, don't hide messages
      if [ "$GSH_MODE" != DEBUG ] || [ -z "$GSH_VERBOSE_DEBUG" ]
      then
        exec 1>/dev/null
        exec 2>/dev/null
      fi

      # under BSD, libintl is installed in /usr/local and we need to pass
      # "-lintl" to the compiler, so we have to try several things!
      {
        echo "GSH: compiling spell.c, first try" >&2
        echo $CC "$MISSION_DIR/spell.c" -lpthread -o "$GSH_VAR/$(gettext "spell")"
        $CC "$MISSION_DIR/spell.c" -lpthread -o "$GSH_VAR/$(gettext "spell")"
      } ||
      {
        echo "GSH: compiling spell.c, second try"
        echo $CC -I/usr/local/include/ -L/usr/local/lib "$MISSION_DIR/spell.c" -lintl -lpthread -o "$GSH_VAR/$(gettext "spell")"
        $CC -I/usr/local/include/ -L/usr/local/lib "$MISSION_DIR/spell.c" -lintl -lpthread -o "$GSH_VAR/$(gettext "spell")"
      }
    ) || { echo "compilation failed" >&2; return 1; }

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
  echo $! > "$GSH_VAR"/spell.pids
  disown
  return 0
}

_mission_init
