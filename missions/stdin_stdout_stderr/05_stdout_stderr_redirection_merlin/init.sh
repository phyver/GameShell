#!/bin/bash

_mission_init() {
  mkdir -p "$(eval_gettext '$GSH_HOME/Castle/Observatory')"

  random_string 200 > "$GSH_VAR/secret_key"

  local CC
  if command -v cc >/dev/null
  then
    CC=cc
  elif command -v c99 >/dev/null
  then
    CC=c99
  elif command -v gcc >/dev/null
  then
    CC=gcc
  elif command -v clang >/dev/null
  then
    CC=clang
  fi

  # some student erase merlin, for example with $ ./merlin > merlin or similar.
  # It is better to re-generate it each time!
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
        echo "GSH: compiling merlin.c, first try" >&2
        echo $CC "$MISSION_DIR/merlin.c" -lpthread -o "$GSH_VAR/merlin"
        $CC "$MISSION_DIR/merlin.c" -lpthread -o "$GSH_VAR/merlin"
      } ||
      {
        echo "GSH: compiling merlin.c, second try"
        echo $CC -I/usr/local/include/ -L/usr/local/lib "$MISSION_DIR/merlin.c" -lintl -lpthread -o "$GSH_VAR/merlin"
        $CC -I/usr/local/include/ -L/usr/local/lib "$MISSION_DIR/merlin.c" -lintl -lpthread -o "$GSH_VAR/merlin"
      }
    ) || { echo "compilation failed" >&2; return 1; }
    copy_bin  "$GSH_VAR/merlin" "$(eval_gettext '$GSH_HOME/Castle/Observatory')/merlin"
  else
    copy_bin  "$MISSION_DIR"/merlin.sh "$(eval_gettext '$GSH_HOME/Castle/Observatory')/merlin"
    chmod 755 "$(eval_gettext '$GSH_HOME/Castle/Observatory')/merlin"
  fi
}

_mission_init
