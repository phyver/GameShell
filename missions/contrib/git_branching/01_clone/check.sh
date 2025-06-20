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

  goal=$GSH_HOME/Castle/Portals
  current="$PWD"

  if [ "$goal" != "$current" ] 
    then 
      echo "You are not in the Portal room"
      return 1
  fi

  al_far_repo=$goal/al_far
  if [ ! -d "$al_far_repo" ]
    then
        echo "The Al Far portal does not seem to be present..."
        return 1
  fi

  al_far_repo_git=$al_far_repo/.git
  if [ ! -d "$al_far_repo_git" ]
    then
        echo "The Al Far portal looks like it is here but the magic is not operating..."
        return 1
  fi

  return 0

}
_mission_check
