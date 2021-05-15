#!/bin/bash

_mission_check() {
  local GREAT_HALL="$(eval_gettext '$GSH_HOME/Castle/Great_hall')"

  if ! cmp -s "$GSH_VAR/great_hall_contents" <(command ls "$GREAT_HALL" | sort)
  then
    echo "$(gettext "You changed the contents of the great hall!")"
    return 1
  fi

  if command ls "$GSH_CHEST" | grep -Eq "$(gettext "decorative_shield")|$(gettext "suit_of_armour")_$(gettext "stag_head")"
  then
    echo "$(gettext "I only wanted the standards!")"
    return 1
  fi

  if ! cmp -s <(grep "$(gettext "standard")" "$GSH_VAR/great_hall_contents") \
    <(command ls "$GSH_CHEST" | sort | grep "$(gettext "standard")")
  then
    echo "$(gettext "I wanted all the standards!")"
    return 1
  fi

  return 0
}

_mission_check
