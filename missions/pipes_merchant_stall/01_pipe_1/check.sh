#!/bin/bash

_mission_check() {
  local amount=$(cat "$GSH_VAR/amountKing")
  local response
  read -erp "$(gettext "How much does the king owe?") " response
  local nb_cmd=$(cat "$GSH_VAR/nb_commands")

  if [ "$response" != "$amount" ]
  then
      echo "$(gettext "That's not the right answer!")"
      return 1
  elif [ "$nb_cmd" -gt 3 ]
  then
    echo "$(eval_gettext "That's the right answer, but you used \$nb_cmd commands!")"
    return 1
  fi
  return 0
}

_mission_check
