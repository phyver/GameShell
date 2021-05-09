#!/bin/bash

source gettext.sh

dir=$(eval_gettext '$GSH_HOME/Castle/Kitchen')
nature=$(gettext "rat_poison")
logfile=$GSH_VAR/rat_poison

"$GSH_VAR"/generator 0 "$logfile-0" "$dir" "$nature" &
echo -n "$!," > "$GSH_VAR"/poison-generator.pid
disown
"$GSH_VAR"/generator 1 "$logfile-1" "$dir" "$nature" &
echo -n "$!," > "$GSH_VAR"/poison-generator.pid
disown
"$GSH_VAR"/generator 2 "$logfile-2" "$dir" "$nature" &
echo -n "$!" > "$GSH_VAR"/poison-generator.pid
disown

trap "" SIGTERM SIGINT
tail -f /dev/null
