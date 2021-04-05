goal=$(CANONICAL_PATH "$(eval_gettext "\$GASH_HOME/Castle/Cellar")")
current=$(CANONICAL_PATH "$PWD")

if [ "$goal" = "$current" ]
then
    unset goal current
    true
else
    echo "$(gettext "You are not in the cellar...")"
    unset goal current
    false
fi
