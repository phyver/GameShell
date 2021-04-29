killall -q cat-generator
rm -f "$(eval_gettext '$GASH_HOME/Castle/Kitchen')/$(gettext "Pantry")"/.*_"$(gettext "wind-up_cat")"
rm -f "$(eval_gettext '$GASH_HOME/Castle/Kitchen')/$(gettext "Pantry")"/*_"$(gettext "wind-up_cat")"
gash check
