#!/bin/sh

# this should be POSIX compliant, but debian's sh (dash) doesn't have fc!

_mission_check() {
  goal=$(realpath "$(eval_gettext "\$GSH_HOME/Castle/Main_building/Throne_room")")
  current=$(realpath "$PWD")

  # TODO: for some unknown reason, redirecting the output of fc into another
  # command shifts the results: it then sees the "gsh check" command that
  # was used to run this function
  # Because of the previous remark, I need to look at the "-3" command.
  # I couldn't find a way to make `fc -nl -3 -3` work on zsh!
  ppc=$(fc -nlr | sed -n '3p;4q' | sed -e 's/^[[:blank:]]*//' -e 's/[[:blank:]]*$//')

  # FIXME: also accept other commands to go back to the starting point?
  # FIXME: add an error message
  [ "$goal" = "$current" ] && [  "$ppc" = "cd" ]
}

_mission_check
