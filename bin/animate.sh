#!/bin/bash

# this script should be source with the command to monitor as argument
# it depends on arguments being passed to a sourced script, which is not
# the case in POSIX, but does work in bash or zsh
# one way to use with a POSIX shell is to do
#    $ set COMMAND TO MONITOR
#    $ . animate.sh COMMAND TO MONITOR
#
LOG=$(mktemp)
"$@" 1>/dev/null 2>"$LOG" &
_PID=$!
animate "$_PID" "$@"
cat "$LOG"
rm -f "$LOG"
unset LOG
wait $_PID

