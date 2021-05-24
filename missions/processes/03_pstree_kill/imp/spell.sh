#!/bin/bash

. gettext.sh

DELAY=3
OFFSET=$1

sleep ${OFFSET:-1}
while true
do
    INDENT=$(echo "                       " | cut -c1-$((2+RANDOM%15)))
    filename="$(eval_gettext '$GSH_HOME/Castle/Cellar')/${RANDOM}_$(gettext "coal")"
    sign_file "$MISSION_DIR/ascii-art/coal-$((RANDOM%4)).txt" "$filename"
    sleep $DELAY & wait $!
done

