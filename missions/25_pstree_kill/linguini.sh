#!/bin/bash

source gettext.sh

dir=$(eval_gettext '$GASH_HOME/Castle/Kitchen')
nature=$(gettext "cheese")
logfile=$GASH_MISSION_DATA/cheese

"$GASH_MISSION_DATA"/generator 0 "$logfile-0" "$dir" "$nature" &
disown
"$GASH_MISSION_DATA"/generator 1 "$logfile-1" "$dir" "$nature" &
disown
"$GASH_MISSION_DATA"/generator 2 "$logfile-2" "$dir" "$nature" &
disown

trap "" SIGTERM SIGINT
tail -f /dev/null
