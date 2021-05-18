#!/bin/bash

y=$(cat "$GSH_VAR/nbUnpaid")
read -erp "$(gettext "How many unpaid items are there?") " d
NB_CMD=$(cat "$GSH_VAR/nb_commands")

x=$(CHECKSUM "$d")

if [ "$NB_CMD" -le 1 ] && [ "$x" == "$y" ]
then
    unset y x d
    true
elif [ "$x" == "$y" ]
then
    echo "$(eval_gettext "That's the right answer, but you used \$NB_CMD commands!")"
    unset y x d NB_CMD
    false
else
    unset y x d NB_CMD
    false
fi
