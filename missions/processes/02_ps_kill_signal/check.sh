#!/bin/bash

# we need to use ps -c to only get the command name and not the full command in
# macOS
# the command name is pretty long as it the processes are not in the path and
# are given as absolute path
# GNU ps truncates the output according to COLUMNS, even when output is not on
# a tty, hence we set COLUMNS to 512 which should be long enough.
_mission_check() {
  local nb_spells=$(COLUMNS=512 ps -cA | grep "$(gettext "spell")" | wc -l | tr -d ' ')

  if [ "$nb_spells" -gt 0 ]
  then
    echo "$(eval_gettext "Some spells (\$nb_spells) are still running!")"
    return 1
  fi

  local nb=$(wc -l "$GSH_VAR/spell.pids" | awk '{print $1}')
  if [ "$nb" -eq 1 ]
  then
    echo "$(gettext "You haven't tried using the standard TERM signal on the spell.")"
    return 1
  fi


  return 0
}

_mission_check
