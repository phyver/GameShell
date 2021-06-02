#!/bin/bash

# this script uses 'disown' to prevent control job messages to appear on the
# screen when cleaning.
# I'm not sure if there is a way to do that in POSIX sh...

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
      if [ "$GSH_MODE" != DEBUG ] || [ -z "$GSH_VERBOSE_DEBUG" ]
      then
        exec 1>/dev/null
        exec 2>/dev/null
      fi

      # under BSD, libintl is installed in /usr/local
      echo "GSH: compiling process.c, first try" >&2 &&
      echo $CC "$MISSION_DIR/process.c" -o "$GSH_VAR/$(gettext "nice_fairy")" &&
      $CC "$MISSION_DIR/process.c" -o "$GSH_VAR/$(gettext "nice_fairy")" ||
      $CC -I/usr/local/include/ -L/usr/local/lib "$MISSION_DIR/process.c" -lintl -o "$GSH_VAR/$(gettext "nice_fairy")" ||
      { echo "compilation failed" >&2; return 1; }

      echo "GSH: compiling process.c, second try" &&
      echo $CC "$MISSION_DIR/process.c" -o "$GSH_VAR/$(gettext "mischievous_imp")" &&
      $CC "$MISSION_DIR/process.c" -o "$GSH_VAR/$(gettext "mischievous_imp")" ||
      $CC -I/usr/local/include/ -L/usr/local/lib "$MISSION_DIR/process.c" -lintl -o "$GSH_VAR/$(gettext "mischievous_imp")" ||
      { echo "compilation failed" >&2; return 1; }

      mkdir -p "$GSH_VAR/fairy/"
      $CC -D WHO=FAIRY "$MISSION_DIR/spell.c" -lpthread -o "$GSH_VAR/fairy/$(gettext "spell")"

      mkdir -p "$GSH_VAR/imp/"
      $CC -D WHO=IMP "$MISSION_DIR/spell.c" -lpthread -o "$GSH_VAR/imp/$(gettext "spell")"
    )

    unset CC

    "$GSH_VAR/$(gettext "nice_fairy")" &
    local PID=$!
    disown "$PID"
    echo "$PID" > "$GSH_VAR/fairy.pid"

    "$GSH_VAR/$(gettext "mischievous_imp")" &
    PID=$!
    disown "$PID"
    echo "$PID" > "$GSH_VAR/imp.pid"

  else

    local BASH_PATH=$(command -v bash)

    { echo "#!$BASH_PATH" ; sed "1d" "$MISSION_DIR/nice_fairy.sh" ; } > "$GSH_VAR/$(gettext "nice_fairy")"
    chmod 755 "$GSH_VAR/$(gettext "nice_fairy")"

    mkdir -p "$GSH_VAR/fairy/"
    cp "$MISSION_DIR/fairy/spell.sh" "$GSH_VAR/fairy/$(gettext "spell")"
    chmod 755 "$GSH_VAR/fairy/$(gettext "spell")"
    "$GSH_VAR/$(gettext "nice_fairy")" &
    local PID=$!
    disown "$PID"
    echo "$PID" > "$GSH_VAR/fairy.pid"

    { echo "#!$BASH_PATH" ; sed "1d" "$MISSION_DIR/mischievous_imp.sh" ; } > "$GSH_VAR/$(gettext "mischievous_imp")"
    chmod 755 "$GSH_VAR/$(gettext "mischievous_imp")"

    mkdir -p "$GSH_VAR/imp/"
    cp "$MISSION_DIR/imp/spell.sh" "$GSH_VAR/imp/$(gettext "spell")"
    chmod 755 "$GSH_VAR/imp/$(gettext "spell")"
    "$GSH_VAR/$(gettext "mischievous_imp")" &
    PID=$!
    disown "$PID"
    echo "$PID" > "$GSH_VAR/imp.pid"

    return 0
  fi
}

_mission_init
