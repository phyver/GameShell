#!/bin/bash

if [ -x /usr/bin/python3 ]
then
    cp "$MISSION_DIR"/generator.py "$GSH_VAR"/generator
else
    cp "$MISSION_DIR"/generator.sh "$GSH_VAR"/generator
fi
chmod 755 "$GSH_VAR"/generator

"$MISSION_DIR"/linguini.sh &
echo $! > "$GSH_VAR/linguini.pid"
disown
"$MISSION_DIR"/skinner.sh &
echo $! > "$GSH_VAR/skinner.pid"
disown

