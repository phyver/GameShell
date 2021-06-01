#!/bin/bash

_mission_check() {
  local nb_unpaid=$(cat "$GSH_VAR/nbUnpaid")
  local response
  read -erp "$(gettext "How many unpaid items are there?") " response
  nb_cmd=$(cat "$GSH_VAR/nb_commands")

  # TODO, check the "boring objects" are still here, to avoid the possibility
  # rm *boring*
  # ...

  if [ "$response" != "$nb_unpaid" ]
  then
      echo "$(gettext "That's not the right answer!")"
      return 1
  elif [ "$nb_cmd" -gt 1 ]
  then
    echo "$(eval_gettext "That's the right answer, but you used \$nb_cmd commands!")"
      return 1
  fi
  return 0
}

_mission_check
