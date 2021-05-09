#!/bin/bash

y=$(cat "$GSH_VAR/amountKing")
read -erp "$(gettext "How much does the king owe?") " d

x=$(checksum "$d")
if [ "$x" = "$y" ]
then
    if [ "$NB_CMD" -le 3 ] && [ "$x" = "$y" ]
    then
        PROMPT_COMMAND=$OLD_PROMPT_COMMAND
        unset OLD_PROMPT_COMMAND NB_CMD y d x
        true
    else
        PROMPT_COMMAND=$OLD_PROMPT_COMMAND
        echo "$(eval_gettext "That's the right answer, but you used \$NB_CMD commands!")"
        unset OLD_PROMPT_COMMAND NB_CMD y d x
        false
    fi
else
    PROMPT_COMMAND=$OLD_PROMPT_COMMAND
    unset OLD_PROMPT_COMMAND NB_CMD y d x
    false
fi
