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

  goal=$GSH_HOME/Castle/Portals/al_jeit
  current="$PWD"

  if [ "$goal" != "$current" ] 
    then 
      echo "You are not in the Al Jeit portal"
      return 1
  fi

  current_branch=$(git branch --show-current)
  if [ "$current_branch" != "spell" ]
    then
        echo "You are not on the spell branch..."
        return 1
  fi

  expected_name="adding_earth"
  branch_created=$(git branch | grep $expected_name)
  if [ "$branch_created" = "" ]
    then
        echo "Improvement $expected_name is not available..."
        return 1
  fi

  expected_name="adding_light"
  branch_created=$(git branch | grep $expected_name)
  if [ "$branch_created" = "" ]
    then
        echo "Improvement $expected_name is not available..."
        return 1
  fi

  # Changing directory as current directoy will be removed by the clean.sh
  cd $GSH_HOME

  return 0

}
_mission_check
