#!/bin/sh

# we need to use ps -c to only get the command name and not the full command in
# macOS
# the command name is pretty long as it the processes are not in the path and
# are given as absolute path
# GNU ps truncates the output according to COLUMNS, even when output is not on
# a tty, hence we set COLUMNS to 512 which should be long enough.
_mission_check() (
  pid=$(cat "$GSH_VAR/spell.pid")
  if COLUMNS=512 ps -cp "$pid" | grep "$(gettext "spell")" >/dev/null
  then
    echo "$(gettext "The spell is still running!")"
    return 1
  fi
  return 0
)

_mission_check
