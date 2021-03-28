#!/bin/bash

y=$(cat "$GASH_TMP/nbImpayes")
read -erp "Combien y a t'il de dettes impayées ? " d

x=$(checksum "$d")

if [ "$NB_CMD" -le 2 ] && [ "$x" == "$y" ]
then
    PROMPT_COMMAND=$(echo "$PROMPT_COMMAND" | sed "s/\s*;\?\s*$_CMD.*//")
    unset NB_CMD y x d _CMD
    true
elif [ "$x" == "$y" ]
then
    echo "C'est la bonne réponse ... mais vous avez utilisé $NB_CMD commandes !"
    PROMPT_COMMAND=$(echo "$PROMPT_COMMAND" | sed "s/\s*;\?\s*$_CMD.*//")
    unset NB_CMD y x d _CMD
    false
else
    PROMPT_COMMAND=$(echo "$PROMPT_COMMAND" | sed "s/\s*;\?\s*$_CMD.*//")
    unset NB_CMD y x d _CMD
    false
fi
