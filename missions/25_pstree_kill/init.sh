#!/bin/bash

if [ -x /usr/bin/python3 ]
then
    cp "$MISSION_DIR"/generator.py "$MISSION_DIR"/generator
else
    cp "$MISSION_DIR"/generator.sh "$MISSION_DIR"/generator
fi
chmod 755 "$MISSION_DIR"/generator

export MISSION_DIR
"$MISSION_DIR"/linguini.sh &
disown
"$MISSION_DIR"/skinner.sh &
disown

