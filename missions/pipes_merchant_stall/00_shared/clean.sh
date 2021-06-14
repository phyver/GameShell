#!/bin/sh

# need to be careful, as there are so many files in the Stall that
# rm .../* may not work.
(
  cd "$(eval_gettext '$GSH_HOME/Stall')"
  find . -type f | xargs rm -f
)

rm -f "$GSH_VAR/nb_commands" "$GSH_VAR/last_command"

PS1=$_PS1
unset _PS1
unset -f _cmd

rm -f "$GSH_VAR/nbUnpaid" "$GSH_VAR/amountKing"
