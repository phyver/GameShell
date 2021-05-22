# need to be subtle, as there are so many files in the Stall that
# rm .../* may not work.
# and find ... -exec rm is too slow
rm -rf "$(eval_gettext '$GSH_HOME/Stall')"
mkdir "$(eval_gettext '$GSH_HOME/Stall')"

# this is to avoid a 'shell-init: error retrieving current directory'
[ "$PWD" = "$(eval_gettext '$GSH_HOME/Stall')" ] && cd "$(eval_gettext '$GSH_HOME/Stall')"

rm -f "$GSH_VAR/nb_commands" "$GSH_VAR/last_command"

PROMPT_COMMAND=$OLD_PROMPT_COMMAND
unset OLD_PROMPT_COMMAND
unset -f _cmd

rm -f "$GSH_VAR/nbUnpaid" "$GSH_VAR/amountKing"
