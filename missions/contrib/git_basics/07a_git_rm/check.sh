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


 if [ ! -e "$GSH_HOME/Castle/Portals/SmallWeels/draft.sh" ]
    then 
      echo " The file  draft.sh does not exist"
      return 1
    else
    echo " The file  date.sh  exists"
    fi

 cd $GSH_HOME/Castle/Portals/SmallWeels/

LANG=en_GB git status | grep -e "Untracked"
 
  test=$(echo $?)
          
  if [ $test -eq 0 ]
    then 
      echo " you not have untracked file"
      return 1
  fi
  

LANG=en_GB git status | grep -e "modified"
 
  test=$(echo $?)
          
  if [ $test -eq 0 ]
    then 
      echo " you a modified file"
      return 1
  fi
  
  

    LANG=en_GB git status | grep -e "up to date with"
test=$(echo $?)
          
  if [ $test -eq 1 ]
    then 
      echo " You did not pushed all of your modifications"
      return 1
    else
      cd $GSH_HOME/Castle/Portals/SmallWeels/

       LANG=en_GB git status | grep -e "Changes to be committed:"
       test=$(echo $?)
      
       if [ $test -eq 0 ]
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
