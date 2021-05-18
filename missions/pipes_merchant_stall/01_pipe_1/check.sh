#!/bin/bash

y=$(cat "$GSH_VAR/amountKing")
read -erp "$(gettext "How much does the king owe?") " d
NB_CMD=$(cat "$GSH_VAR/nb_commands")

x=$(CHECKSUM "$d")
if [ "$x" = "$y" ]
then
    if [ "$NB_CMD" -le 3 ] && [ "$x" = "$y" ]
    then
        unset y d x NB_CMD
        true
    else
        echo "$(eval_gettext "That's the right answer, but you used \$NB_CMD commands!")"
        unset y d x NB_CMD
        false
    fi
else
    unset y d x NB_CMD
    false
fi
