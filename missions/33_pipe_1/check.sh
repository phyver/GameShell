#!/bin/bash

y=$(cat "$GASH_TMP/detteDuDuc")
read -p "Quelle est la dette du Duc ? " d

x=$(checksum "$d")
if [ "$NB_CMD" -ge 0  -a  "$x" = "$y" ]
then
    PROMPT_COMMAND=$OLD_PROMPT_COMMAND
    unset OLD_PROMPT_COMMAND NB_CMD y d x
    true
else
    PROMPT_COMMAND=$OLD_PROMPT_COMMAND
    unset OLD_PROMPT_COMMAND NB_CMD y d x
    false
fi
