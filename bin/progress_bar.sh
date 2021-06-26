# this script should be sourced with the command to monitor as argument
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
  stderr_log=$(mktemp)
  [ -n "$GSH_NON_INTERACTIVE" ] || set +o monitor # do not monitor background processes
  # don't use trap, because it will overwrite existing traps in the main
  # shell!
  # trap "set -m" TERM INT EXIT HUP
  "$@" 1>/dev/null 2>"$stderr_log" &
  _PID=$!
  set --    # unset all positional parameters
  progress_bar -b "$design" $_PID
  wait $_PID
  ret_value=$?  # save return value of command
  [ -n "$GSH_NON_INTERACTIVE" ] || set -o monitor  # monitor background processes (default)
  cat "$stderr_log"
  rm -f "$stderr_log"
  unset stderr_log design _PID
  eval "unset ret_value; ( exit $ret_value )" # return value, unsetting the corresponding variable
fi
