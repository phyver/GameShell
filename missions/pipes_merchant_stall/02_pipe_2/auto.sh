#!/usr/bin/env bash

# FIXME? I use bash' process substitution to avoid creating a subshell

cd "$(eval_gettext '$GSH_HOME/Stall')"

# beware, there are so many files that we may get "bash: /usr/bin/grep: Argument list too long"
# so we use recursive grep on the directory instead of globbing
gsh check < <(grep -rv "$(gettext "PAID")" "$(eval_gettext '$GSH_HOME/Stall')" | wc -l)
