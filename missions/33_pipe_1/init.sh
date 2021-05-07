#!/bin/bash

# fichier lu par le shell à chaque démarrage de la mission

rm -f "$(eval_gettext '$GSH_HOME/Stall')"/*
"$GSH_LOCAL_BIN/genStall.py" 10000 2000 0.995 "$(eval_gettext '$GSH_HOME/Stall')"

export NB_CMD=0
_CMD='echo "($NB_CMD)"; NB_CMD=$(( NB_CMD + 1 ))'
PROMPT_COMMAND=$(echo "$PROMPT_COMMAND" | sed "s/\s*;\?\s*$_CMD.*//")
if [ -z "$PROMPT_COMMAND" ]
then
    PROMPT_COMMAND="$_CMD"
else
    PROMPT_COMMAND="$PROMPT_COMMAND;$_CMD"
fi
