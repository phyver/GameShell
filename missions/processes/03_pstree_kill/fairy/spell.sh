#!/usr/bin/env bash

source gettext.sh

DELAY=3
OFFSET=$1

sleep ${OFFSET:-1}
while true
do
    INDENT=$(echo "                       " | cut -c1-$((2+RANDOM%15)))
    filename="$(eval_gettext '$GSH_HOME/Castle/Cellar')/${RANDOM}_$(gettext "snowflake")"
    sign_file "$MISSION_DIR/ascii-art/snowflake-$((RANDOM%4)).txt" "$filename"
    echo "${filename#$(eval_gettext '$GSH_HOME/Castle/Cellar')/}" >> "$GSH_VAR/snowflakes-$OFFSET.list"
    sleep $DELAY & wait $!
done

