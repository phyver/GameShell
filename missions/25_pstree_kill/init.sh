#!/bin/bash

if [ -x /usr/bin/python3 ]
then
    cp "$MISSION_DIR"/generator.py "$GSH_MISSION_DATA"/generator
else
    cp "$MISSION_DIR"/generator.sh "$GSH_MISSION_DATA"/generator
fi
chmod 755 "$GSH_MISSION_DATA"/generator

"$MISSION_DIR"/linguini.sh &
disown
"$MISSION_DIR"/skinner.sh &
disown

