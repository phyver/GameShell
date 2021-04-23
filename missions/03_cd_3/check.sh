# Turn history on (off by default for non-interactive shells).
HISTFILE=$GASH_DATA/history

goal=$(REALPATH "$(eval_gettext "\$GASH_HOME/Castle/Main_building/Throne_room")")
current=$(REALPATH "$PWD")

# The third-to-last command in the history (xargs removes trailing spaces).
ppc=$(fc -nl -3 -3 | xargs)

# TODO also accept other commands to go back to the starting point?
if [ "$goal" = "$current" ] && [  "$ppc" = "cd" ]
then
    unset ppc goal current
    true
else
    unset ppc goal current
    false
fi
