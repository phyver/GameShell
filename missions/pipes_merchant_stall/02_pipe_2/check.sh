#!/bin/bash

y=$(cat "$GSH_VAR/nbUnpaid")
read -erp "$(gettext "How many unpaid items are there?") " d

x=$(CHECKSUM "$d")

if [ "$NB_CMD" -le 2 ] && [ "$x" == "$y" ]
then
    PROMPT_COMMAND=$(echo "$PROMPT_COMMAND" | sed "s/\s*;\?\s*$_CMD.*//")
    unset NB_CMD y x d _CMD
    true
elif [ "$x" == "$y" ]
then
    echo "$(eval_gettext "That's the right answer, but you used \$NB_CMD commands!")"
    PROMPT_COMMAND=$(echo "$PROMPT_COMMAND" | sed "s/\s*;\?\s*$_CMD.*//")
    unset NB_CMD y x d _CMD
    false
else
    PROMPT_COMMAND=$(echo "$PROMPT_COMMAND" | sed "s/\s*;\?\s*$_CMD.*//")
    unset NB_CMD y x d _CMD
    false
fi
