#!/usr/bin/env sh

# This file is not required: it is sourced every time the mission is started.
# Since it is sourced every time the mission is restarted, it can generate
# random data to make each run slightly different.
#
# Since it is sourced, it may define environment variables if you really need
# them, but it should "unset" any local variable it has created.
#
# Note however that should the mission be initialized in a subshell, those
# environment variables will disappear! That typically happens a mission is
# checked using process redirection, as in
#   $ SOMETHING | gsh check
# To mitigate the problem, GameShell will display a message asking the player
# to run
#   $ gsh reset
# in that case.
#
# It typically looks like
_mission_init() {
  # ...
  if ! git --version > /dev/null 2 > /dev/null
    then  echo "git not found"
    return 1
  fi

  . $GSH_TMP/clone.sh &> /dev/null 
  . $GSH_TMP/co.sh &> /dev/null
  git reset --hard adding_light &> /dev/null
  git checkout -b power 0c522b5 &> /dev/null
  
}
_mission_init
