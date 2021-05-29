#!/bin/sh

# this script should be source with the command to monitor as argument
# it depends on arguments being passed to a sourced script, which is not
# the case in POSIX, but does work in bash or zsh
# one way to use with a POSIX shell is to do set ARGV manually with
#    $ set -- COMMAND TO MONITOR
#    $ . progress_bar.sh COMMAND TO MONITOR
#
# NOTE: it can be executed as well, but the given command will be executed in
# a subshell, so the environment might be different

if [ -z "$*" ]
then
  cat <<EOS >&2
usage:
  . progress_bar.sh [-b DESIGN] COMMAND
or
  set -- [-b DESIGN] COMMAND
  . progress_bar.sh [-b DESIGN] COMMAND
if your shell is stricly POSIX
EOS
  false
else
  design=RANDOM
  if [ "$1" = "-b" ]
  then
    design=$2
    shift 2
  fi
  LOG=$(mktemp)
  "$@" 1>/dev/null 2>"$LOG" &
  _PID=$!
  progress_bar -b "$design" $_PID
  cat "$LOG"
  rm -f "$LOG"
  unset LOG
  wait $_PID
fi
