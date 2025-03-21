#!/usr/bin/env sh

# this should be POSIX compliant, but debian's sh (dash) doesn't have fc!

_mission_check() {
  goal=$(readlink-f "$(eval_gettext "\$GSH_HOME/Castle/Main_building/Throne_room")")
  current=$(readlink-f "$PWD")

  ppc=$(. fc-lnr.sh | grep -v '^[[:blank:]]*gsh' | sed -n '2p;3q')

  # FIXME: also accept other commands to go back to the starting point?
  # FIXME: add an error message
  [ "$goal" = "$current" ] && [  "$ppc" = "cd" ]
}

_mission_check
