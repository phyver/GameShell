# shows the 10 previous commands using fc -nlr
# this must be SOURCED
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

fc -nl |                                              # get the history
  tail -n 11 |                                        # keep at most the last 11 commands
  awk '{L[l++]=$0} END {while (l>0) print L[--l]}' |  # reverse the lines, to get last command on first line
  awk 'NR==1 && $0 ~ "gsh *check" {next}; {print}' |  # remove the first line, if it matches "gsh *check"
  sed -e "s/^[[:blank:]]*//"  -e "s/[[blank:]]*$//"   # remove leading /trailing spaces
