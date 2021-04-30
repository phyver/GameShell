ps -e | awk '/cat-generator/ {print $1}' | xargs kill -9 2> /dev/null
rm -f "$(eval_gettext '$GASH_HOME/Castle/Kitchen')/$(gettext "Pantry")"/.*_"$(gettext "wind-up_cat")"
rm -f "$(eval_gettext '$GASH_HOME/Castle/Kitchen')/$(gettext "Pantry")"/*_"$(gettext "wind-up_cat")"
gash check
