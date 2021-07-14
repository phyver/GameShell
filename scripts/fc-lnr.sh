# shows the 10 previous commands using fc -nlr
# this must be SOURCED
#
# if the script receives a $1 argument, it is used instead of "10".
# (You can either rely on bash / zsh ability to pass arguments while sourcing,
# or set it explicitly with
#      set NB ; . fc-lnr.sh
#
# This script is necessary because of some strange behaviour with bash:
# when sourcing a script from inside a function, the function call is added
# during the "source", removed after the "source", and added again after the
# function:
#
#    $ echo "fc -l; echo" > f
#    $ f() { fc -l ; echo ; source ./f ; fc -l ; echo ; }
#    $ f
#    1        echo "fc -l; echo" > f
#    2        f() { fc -l ; echo ; source ./f ; fc -l ; echo ; }
#
#    1        echo "fc -l; echo" > f
#    2        f() { fc -l ; echo ; source ./f ; fc -l ; echo ; }
#    3        f    <<<<<<<<<<<<<<<<< WHY IS THIS HERE
#
#    1        echo "fc -l; echo" > f
#    2        f() { fc -l ; echo ; source ./f ; fc -l ; echo ; }
#
# Strangely enough, this doesn't happen in non-interactive mode!
#
# This happens when running "gsh check", which sources (via "mission_source")
# the "check.sh" file.
#
# Since inspecting the history is only used in "check.sh" scripts, the
# additionnal command is always "gsh check".
# As an ugly fix, I manually remove that additional command!

# expand the first line if it is an alias, and remove it if it contains "gsh check"
# (if the first line is not alias, or it doesn't contain "gsh check", the first line
# is left unchanged)
# The other lines are unchanged.


# recursively expand (using aliases) the head of the command
_expand() (
  i=$1
  if [ "$i" -gt 32 ]
  then
    echo "fc-lnr.sh: _expand: too many nested aliases: $1"
    echo -- "$@"
    return
  fi
  shift
  _cmd=$1
  if _exp=$(alias "$_cmd" 2>/dev/null)
  then
    shift
    # remove everything before the "=" to get the expansion
    # and remove the quotes around the expansion
    _tmp=$(echo "${_exp#*=}" | sed -e "s/^['\"]//" -e "s/['\"]$//")
    _expand ""$((i+1)) $_tmp "$@"
  else
    echo -- "$@"
  fi
)

_filter_first() (
  read -r _cmd
  _exp=$(_expand 1 $_cmd)
  if ! echo "$_exp" | grep -q "gsh *check"
  then
    printf '%s\n' "$_cmd"
  fi
  cat
)

fc -nrl |                                              # get the history
  head -n "${1:-10}" |                                 # keep at most 10 commands
  sed -e "s/^[[:blank:]]*//" -e "s/[[:blank:]]*$//" |   # remove leading /trailing spaces
  _filter_first


unset -f _filter_first _expand

set --
