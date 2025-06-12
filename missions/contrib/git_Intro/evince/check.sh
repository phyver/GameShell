#!/usr/bin/env sh

# This file is required. It is sourced when checking the goal of the mission
# has been achieved.
# It should end with a command returning 0 on success, and something else on
# failure.
# It should "unset" any local variable it has created, and any "global
# variable" that were only used for the mission. (The function _mission_check
# is automatically unset.)
#
# It typically looks like

_mission_check() {


  printf "%s " "$(gettext "Please cast the spell you found on the scroll")"
  read -r r

  if [ "$r" != "42" ]
  then
    echo "$(gettext "That's not the correct spell! Please read the scroll again")"
    return 1
  fi

#   if [ -t 0 ]
#   then
#     # got input interactively from a tty
#     echo "$(gettext "That's correct, but you need to use a redirection to complete this mission!")"
#     return 1
#   fi
#   return 0
    
    return 0 
}
_mission_check
