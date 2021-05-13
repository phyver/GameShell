#!/bin/bash

_mission_check () {
  local ENTRANCE="$(eval_gettext '$GSH_HOME/Castle/Entrance')"

  if ! cmp -s "$GSH_VAR/entrance_contents" <(command ls "$ENTRANCE" | sort)
  then
    echo "$(gettext "You changed the contents of the entrance!")"
    return 1
  fi

  if command ls "$GSH_CHEST" | grep -Eq "$(gettext "decorative_shield")|$(gettext "suit_of_armour")_$(gettext "stag_head")"
  then
    echo "$(gettext "I only wanted the tapestries!")"
    return 1
  fi

  if ! cmp -s <(grep "$(gettext "tapestry")" "$GSH_VAR/entrance_contents") \
    <(command ls "$GSH_CHEST" | sort | grep "$(gettext "tapestry")")
  then
    echo "$(gettext "I wanted all the tapestries!")"
    return 1
  fi

  return 0
}

_mission_check
