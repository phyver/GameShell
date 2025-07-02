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

check_answer() {
result=$1
error_str=$2
read -r response
case "$response" in
  "" | *[!0-9]*)
    echo "That's not even a number!"
    return 1
    ;;
  *)
    if [ "$response" -ne $result ]
    then
      echo $error_str
      return 1
    fi
    ;;
esac
}

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


echo "If we want to merge the adding_light branch into spell, which kind of merge it is ?"
echo "1. a fast-forward merge"
echo "2. a real merge"
res="1"
err_str="Too bad! The answer was $res. Indeed, it is a fast forward merge as there is a single direct link between the commit of the spell branch and the commit pointed by the adding_light branch"
check_answer "$res" "$err_str"
if [ $? = "1" ] ; then return 1 ; fi

echo "If we want to merge the adding_earth branch into spell, which kind of merge it is ?"
echo "1. a fast-forward merge"
echo "2. a real merge"
res="2"
err_str="Too bad! The answer was $res. Indeed, it is a real merge because the history has diverged between the spell branch and adding_earth branch."
check_answer "$res" "$err_str"
if [ $? = "1" ] ; then return 1 ; fi

echo "What is the first ingredient of the spell on the spell branch (provide the number) ?"
res="77"
err_str="Too bad! The answer was $res."
check_answer "$res" "$err_str"
if [ $? = "1" ] ; then return 1 ; fi

echo "What is the first ingredient of the spell on the adding_light branch (provide the number) ?"
res="77"
err_str="Too bad! The answer was $res."
check_answer "$res" "$err_str"
if [ $? = "1" ] ; then return 1 ; fi

echo "What is the first ingredient of the spell on the adding_earth branch (provide the number) ?"
res="44"
err_str="Too bad! The answer was $res."
check_answer "$res" "$err_str"
if [ $? = "1" ] ; then return 1 ; fi
  
}
_mission_check
