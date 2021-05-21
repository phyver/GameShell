#!/bin/bash

_mission_check() {
  local nb_unpaid=$(cat "$GSH_VAR/nbUnpaid")
  local response
  read -erp "$(gettext "How many unpaid items are there?") " response
  NB_CMD=$(cat "$GSH_VAR/nb_commands")

  if [ "$response" != "$nb_unpaid" ]
  then
      echo "$(gettext "That's not the right answer!")"
      return 1
  elif [ "$NB_CMD" -gt 1 ]
  then
    echo "$(eval_gettext "That's the right answer, but you used \$NB_CMD commands!")"
      return 1
  fi
  return 0
}

_mission_check
