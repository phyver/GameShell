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

 if [ ! -e "$GSH_HOME/Castle/Portals/SmallWeels/Chapter_1/date.sh" ]
    then 
      echo " The file  date.sh is not in Chapter_1"
      return 1
    else
    echo " The file  date.sh  is in Chapter_1"
    fi
    
 if [ ! -e "$GSH_HOME/Castle/Portals/SmallWeels/Chapter_1/truth.sh" ]
    then 
      echo " The file  truth.sh is not in Chapter_1"
      return 1
    else
    echo " The file  truth.sh  is in Chapter_1"
    fi


  # verifier que le repertoire existe et est un depot git
  LANG=en_GB git status | grep -e "up to date with"

  if [ ! $? ]
    then 
      echo " You did not pushed all of your modifications"
      return 1
    else
     LANG=en_GB   git status | grep -e "nothing to commit"
        test=$(echo $?)
          if [ ! $test ]
            then 
               echo " You did not commited all of your modifications"
           return 1
          else 
           echo " You did pushed all of your modifications"
         return 0 
         fi
    fi
    
    
    
}
_mission_check
