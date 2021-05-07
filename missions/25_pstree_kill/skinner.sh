#!/bin/bash

source gettext.sh

dir=$(eval_gettext '$GSH_HOME/Castle/Kitchen')
nature=$(gettext "rat_poison")
logfile=$GSH_VAR/rat_poison

"$GSH_VAR"/generator 0 "$logfile-0" "$dir" "$nature" &
disown
"$GSH_VAR"/generator 1 "$logfile-1" "$dir" "$nature" &
disown
"$GSH_VAR"/generator 2 "$logfile-2" "$dir" "$nature" &
disown

trap "" SIGTERM SIGINT
tail -f /dev/null
