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

  log=$(git branch --merged | grep "power")
  if [ "$log" = "" ]
    then
        echo "power branch is not merged..."
        return 1
  fi

  diff_res=$(diff dragon_killer.spell $MISSION_DIR/dragon_killer.spell)
  if [ "$log" = "" ]
    then
        echo "The spell does not like expected, you may have solved the conflict the wrong way..."
        return 1
  fi

  return 0

}
_mission_check
