#!/bin/bash

_mission_check() {
  local nb_spells=$(ps -ce | grep "$(gettext "spell")" | wc -l | tr -d ' ')

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
