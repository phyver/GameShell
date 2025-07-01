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


echo "If we want to merge the new_ingredient branch into main, which kind of merge it is ?"
echo "1. a fast-forward merge"
echo "2. a real merge"
res="1"
err_str="Too bad! The answer was $res. Indeed, it is a fast forward merge as there is a single direct link between the commit of the main branch and the commit pointed by the new_ingredient branch"
check_answer "$res" "$err_str"
if [ $? = "1" ] ; then return 1 ; fi

echo "If we want to merge the add_rune branch into main, which kind of merge it is ?"
echo "1. a fast-forward merge"
echo "2. a real merge"
res="2"
err_str="Too bad! The answer was $res. Indeed, it is a real merge because the history has diverged between the main branch and add_rune branch."
check_answer "$res" "$err_str"
if [ $? = "1" ] ; then return 1 ; fi

echo "What is the first ingredient of the spell on the main branch (provide the number) ?"
res="11"
err_str="Too bad! The answer was $res."
check_answer "$res" "$err_str"
if [ $? = "1" ] ; then return 1 ; fi

echo "What is the first ingredient of the spell on the new_ingredient branch (provide the number) ?"
res="11"
err_str="Too bad! The answer was $res."
check_answer "$res" "$err_str"
if [ $? = "1" ] ; then return 1 ; fi

echo "What is the first ingredient of the spell on the add_rune branch (provide the number) ?"
res="33"
err_str="Too bad! The answer was $res."
check_answer "$res" "$err_str"
if [ $? = "1" ] ; then return 1 ; fi
  

# Changing directory as current directoy will be removed by the clean.sh
cd $GSH_HOME

}
_mission_check
