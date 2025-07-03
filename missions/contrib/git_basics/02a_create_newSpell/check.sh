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


 if [ ! -e "$GSH_HOME/Castle/Portals/SmallWeels/date.sh" ]
    then 
      echo " The file  date.sh doesn't exist"
      return 1
    else
    echo " The file  date.sh  exist"
    fi

  # verifier que le repertoire existe et est un depot git
   LANG=en_GB git status | grep -e "Untracked"

  if [ ! $? ]
    then 
      echo " you should have some untracked file"
      return 1
    else
        git status | grep -e "nothing to commit"
        test=$(echo $?)
          if [ ! $test ]
            then 
               echo " Good, you did not commited your modifications"
           return 0
          else 
           echo " You should not have commited your modifications"
         return 1 
         fi
    fi
   


}
_mission_check
