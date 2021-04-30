#!/bin/bash

if [ -x /usr/bin/python3 ]
then
    cp "$MISSION_DIR"/generator.py "$GASH_MISSION_DATA"/generator
else
    cp "$MISSION_DIR"/generator.sh "$GASH_MISSION_DATA"/generator
fi
chmod 755 "$GASH_MISSION_DATA"/generator

"$MISSION_DIR"/linguini.sh &
disown
"$MISSION_DIR"/skinner.sh &
disown

