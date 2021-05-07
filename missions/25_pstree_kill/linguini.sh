#!/bin/bash

source gettext.sh

dir=$(eval_gettext '$GSH_HOME/Castle/Kitchen')
nature=$(gettext "cheese")
logfile=$GSH_VAR/cheese

"$GSH_VAR"/generator 0 "$logfile-0" "$dir" "$nature" &
echo -n "$!," > "$GSH_VAR"/cheese-generator.pid
disown
"$GSH_VAR"/generator 1 "$logfile-1" "$dir" "$nature" &
echo -n "$!," >> "$GSH_VAR"/cheese-generator.pid
disown
"$GSH_VAR"/generator 2 "$logfile-2" "$dir" "$nature" &
echo -n "$!" >> "$GSH_VAR"/cheese-generator.pid
disown

trap "" SIGTERM SIGINT
tail -f /dev/null
