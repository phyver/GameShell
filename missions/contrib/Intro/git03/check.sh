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

  # verifier que le repertoire existe et est un depot git

  printf "%s " "$(gettext "Please type your github login")"
  read -r r

  if [ -z "$r"  ]
  then
      echo " login not provided"
    return 1
  else
      echo " The login you provided is $r "
      
      printf "%s " "$(gettext "is that correct ? [y/n]")"
      read -r s

       if [ "$s" != "y" ]
          then
          echo "$(gettext "please try again to provid your login")"
       return 1
       fi

  fi
    return 0 
}
_mission_check
