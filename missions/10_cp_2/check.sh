#!/bin/bash

_mission_check () {
  local ENTRANCE="$(eval_gettext '$GSH_HOME/Castle/Entrance')"

  if ! cmp -s "$GSH_MISSION_DATA/entrance_contents" <(command ls "$ENTRANCE" | sort)
  then
    echo "$(gettext "You changed the contents of the entrance!")"
    return 1
  fi

  if command ls "$GSH_CHEST" | grep -Eq "_$(gettext "hay")|_$(gettext "gravel")|_$(gettext "garbage")"
  then
    echo "$(gettext "I only wanted the ornaments!")"
    return 1
  fi

  if ! cmp -s <(grep "_$(gettext "ornament")" "$GSH_MISSION_DATA/entrance_contents") \
    <(command ls "$GSH_CHEST" | sort | grep "_$(gettext "ornament")")
  then
    echo "$(gettext "I wanted all the ornements!")"
    return 1
  fi

  return 0
}

_mission_check
