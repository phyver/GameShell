#!/bin/sh

_mission_init() {

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
      echo $CC "$MISSION_DIR/spell.c" -o "$GSH_VAR/$(gettext "spell")"
      $CC "$MISSION_DIR/spell.c" -o "$GSH_VAR/$(gettext "spell")"
    ) || { echo "compilation failed" >&2; return 1; }
  else
    cp "$MISSION_DIR/spell.sh" "$GSH_VAR/$(gettext "spell")"
    chmod 755 "$GSH_VAR/$(gettext "spell")"
  fi
  "$GSH_VAR/$(gettext "spell")" &
  echo $! > "$GSH_VAR"/spell.pid
  return 0
}

set +o monitor  # do not monitor background processes
# FIXME: for some unknown reason, this doesn't work if we start with this
# mission directly!

set +b; _mission_init
