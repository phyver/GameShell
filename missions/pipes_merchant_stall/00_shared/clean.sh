rm -rf "$(eval_gettext '$GSH_HOME/Stall')"/*
rm -f "$GSH_VAR/nb_commands" "$GSH_VAR/last_command"

PROMPT_COMMAND=$OLD_PROMPT_COMMAND
unset OLD_PROMPT_COMMAND NB_CMD
unset -f _cmd

rm -f "$GSH_VAR/nbUnpaid" "$GSH_VAR/amountKing"
