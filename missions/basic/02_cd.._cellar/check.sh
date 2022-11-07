#!/usr/bin/env sh

goal=$(readlink-f "$(eval_gettext "\$GSH_HOME/Castle/Cellar")")
current=$(readlink-f "$PWD")

if [ "$goal" = "$current" ]
then
    unset goal current
    true
else
    echo "$(gettext "You are not in the cellar...")"
    unset goal current
    false
fi
