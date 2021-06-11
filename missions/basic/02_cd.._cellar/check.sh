#!/bin/sh

goal=$(realpath "$(eval_gettext "\$GSH_HOME/Castle/Cellar")")
current=$(realpath "$PWD")

if [ "$goal" = "$current" ]
then
    unset goal current
    true
else
    echo "$(gettext "You are not in the cellar...")"
    unset goal current
    false
fi
