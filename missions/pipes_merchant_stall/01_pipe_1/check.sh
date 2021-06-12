#!/bin/sh

_mission_check() (
  amount=$(cat "$GSH_VAR/amountKing")
  printf "%s " "$(gettext "How much does the king owe?")"
  read -r response
  nb_cmd=$(cat "$GSH_VAR/nb_commands")

  # TODO, check the "boring objects" are still here, to avoid the possibility
  # rm *boring*
  # ...

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
)

_mission_check
