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
  git config --local user.email
  if [ ! $? ]
    then 
     git config --global user.email
     if [ ! $? ]
      then
      echo " There is no user.email defined localy or globaly for git"
      return 1
    else
    echo " user.email is defined"
    fi
  fi 
  git config --local user.name
  if [ ! $? ]
    then 
      git config --global user.name
     if [ ! $? ]
     then
      echo " There is no user.name definen localy or globaly for git"
      return 1
    else
    echo " user.name is definen"
     fi
  fi
    
    
    return 0 
}
_mission_check
