#!/bin/bash
#
# FIXME? I use bash' process substitution to avoid creating a subshell

cd "$(eval_gettext '$GSH_HOME/Stall')"

# beware, there are so many files that we may get "bash: /usr/bin/grep: Argument list too long"
# so we use recursive grep on the diectory instead of globbing
gsh check < <(grep -r "$(gettext "the King")" "$(eval_gettext '$GSH_HOME/Stall')" |
              grep -v "$(gettext "PAID")" |
              grep -o "[0-9]* [^0-9]*$" |
              awk '{s+=$1} END{print s}')
