#!/bin/sh

_mission_init() {

  if command -v gcc >/dev/null
  then
    CC=gcc
    if [ "$GSH_MODE" = DEBUG ]
    then
      CFLAGS="-std=c99 -Wall -Wextra -pedantic"
    fi
  elif command -v clang >/dev/null
  then
    CC=clang
    if [ "$GSH_MODE" = DEBUG ]
    then
      CFLAGS="-std=c99 -Wall -Wextra -pedantic"
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
        echo $CC $CFLAGS "$MISSION_DIR/spell.c" -lpthread -o "$GSH_TMP/$(gettext "spell")"
        $CC $CFLAGS "$MISSION_DIR/spell.c" -lpthread -o "$GSH_TMP/$(gettext "spell")"
      } ||
      {
        echo "GSH: compiling spell.c, second try"
        echo $CC $CFLAGS -I/usr/local/include/ -L/usr/local/lib "$MISSION_DIR/spell.c" -lintl -lpthread -o "$GSH_TMP/$(gettext "spell")"
        $CC $CFLAGS -I/usr/local/include/ -L/usr/local/lib "$MISSION_DIR/spell.c" -lintl -lpthread -o "$GSH_TMP/$(gettext "spell")"
      }
    ) || { echo "compilation failed" >&2; return 1; }

  else
    cp "$MISSION_DIR/spell.sh" "$GSH_TMP/$(gettext "spell")"
    chmod 755 "$GSH_TMP/$(gettext "spell")"
  fi
  "$GSH_TMP/$(gettext "spell")" &
  echo $! > "$GSH_TMP"/spell.pids
  return 0
}

[ -n "$GSH_NON_INTERACTIVE" ] || set +o monitor  # do not monitor background processes
# FIXME: for some unknown reason, this doesn't work if we start with this
# mission directly!

_mission_init
