goal=$(REALPATH "$(eval_gettext "\$GASH_HOME/Castle/Cellar")")
current=$(REALPATH "$PWD")

if [ "$goal" = "$current" ]
then
    unset goal current
    true
else
    echo "$(gettext "You are not in the cellar...")"
    unset goal current
    false
fi
