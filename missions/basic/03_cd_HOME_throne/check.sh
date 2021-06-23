#!/bin/sh

# this should be POSIX compliant, but debian's sh (dash) doesn't have fc!

_mission_check() {
  goal=$(realpath "$(eval_gettext "\$GSH_HOME/Castle/Main_building/Throne_room")")
  current=$(realpath "$PWD")

  ppc=$(. previous_commands.sh | sed -n '2p;3q')

  # FIXME: also accept other commands to go back to the starting point?
  # FIXME: add an error message
  [ "$goal" = "$current" ] && [  "$ppc" = "cd" ]
}

_mission_check
