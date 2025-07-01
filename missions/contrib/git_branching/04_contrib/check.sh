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
  if [ "$current_branch" != "power" ]
    then
        echo "You are not on the power branch..."
        return 1
  fi

  ci_main=$(git branch -vv | grep main | tr -s ' ' | cut -d ' ' -f 3)
  ci_power=$(git log --oneline -n 1 |cut -d ' ' -f 1)
  if [ "$ci_main" = "$ci_power" ]
    then
        echo "main and power branches are pointing on the same commit, looks like there is no new contribution added to the portal..."
        return 1
  fi

  # Changing directory as current directoy will be removed by the clean.sh
  cd $GSH_HOME

  return 0

}
_mission_check
