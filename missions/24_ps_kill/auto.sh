killall -q cat_generator cat-generator
rm "$(eval_gettext '$GASH_HOME/Castle/Cellar')/".*_"$(gettext "cat")"
gash check
