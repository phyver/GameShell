#!/bin/bash

goal=$(REALPATH "$(eval_gettext "\$GSH_HOME/Castle/Main_building/Throne_room")")
current=$(REALPATH "$PWD")

# TODO: for some unknown reason, redirecting the output of fc into another
# command shifts the results: it then sees the "gsh check" command that
# was used to run this function
# Because of the previous remark, I need to look at the "-3" command.
ppc=$(fc -nl -3 -3 | sed 's/^\s*//' | sed 's/\s*$//')

# TODO also accept other commands to go back to the starting point?
if [ "$goal" = "$current" ] && [  "$ppc" = "cd" ]
then
    unset ppc goal current
    true
else
    unset ppc goal current
    false
fi
