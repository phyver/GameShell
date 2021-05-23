#!/bin/bash

_mission_init() {
  cat > "$(eval_gettext '$GSH_HOME/Castle/Main_building/Library')/$(gettext "Greek_Latin_and_other_modern_languages")" <<EOB
Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
consequat.  Duis aute irure dolor in reprehenderit in voluptate velit esse
cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
EOB

echo "$(gettext "The book 'Mathematics_101' contains all the anwsers.
Just copy all its lines to get perfect score.")" \
  > "$(eval_gettext '$GSH_HOME/Castle/Main_building/Library')/.$(gettext "How_to_cheat_for_exams")"


  local book="$(eval_gettext '$GSH_HOME/Castle/Main_building/Library')/$(gettext "Mathematics_101")"
  rm -f "$book"
  local questions=$GSH_VAR/arith.txt
  rm -f "$questions"

  for _ in $(seq 100)
  do
    local a=$((1+RANDOM%100))
    local b=$((1+RANDOM%100))
    local r=$((a * b))
    echo $r >> "$book"
    echo "$a * $b = ?? |$r" >> "$questions"
  done
}

_mission_init
