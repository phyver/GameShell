#!/bin/sh

_mission_check() (
  nb_spells=$(my_ps | grep -c "$(gettext "spell")" | tr -d ' ')

  if [ "$nb_spells" -gt 0 ]
  then
    echo "$(eval_gettext "Some spells (\$nb_spells) are still running!")"
    return 1
  fi

  nb=$(wc -l "$GSH_TMP/spell.pids" | awk '{print $1}')
  if [ "$nb" -eq 1 ]
  then
    echo "$(gettext "You haven't tried using the standard TERM signal on the spell.")"
    return 1
  fi

  return 0
)

_mission_check
