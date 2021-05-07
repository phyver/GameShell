#!/bin/bash

source gettext.sh

dir=$(eval_gettext '$GSH_HOME/Castle/Kitchen')
nature=$(gettext "cheese")
logfile=$GSH_MISSION_DATA/cheese

"$GSH_MISSION_DATA"/generator 0 "$logfile-0" "$dir" "$nature" &
disown
"$GSH_MISSION_DATA"/generator 1 "$logfile-1" "$dir" "$nature" &
disown
"$GSH_MISSION_DATA"/generator 2 "$logfile-2" "$dir" "$nature" &
disown

trap "" SIGTERM SIGINT
tail -f /dev/null
