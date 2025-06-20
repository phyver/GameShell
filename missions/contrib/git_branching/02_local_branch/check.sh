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

  goal=$GSH_HOME/Castle/Portals/al_far
  current="$PWD"

  if [ "$goal" != "$current" ] 
    then 
      echo "You are not in the Al Far portal"
      return 1
  fi

  current_branch=$(git branch --show-current)
  if [ "$current_branch" != "main" ]
    then
        echo "You are not on the main branch..."
        return 1
  fi

  expected_name="new_ingredient"
  branch_created=$(git branch | grep $expected_name)
  if [ "$branch_created" = "" ]
    then
        echo "Improvement $expected_name is not available..."
        return 1
  fi

  expected_name="add_rune"
  branch_created=$(git branch | grep $expected_name)
  if [ "$branch_created" = "" ]
    then
        echo "Improvement $expected_name is not available..."
        return 1
  fi

  return 0

}
_mission_check
