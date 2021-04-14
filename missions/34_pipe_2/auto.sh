gash check < <(grep -v "$(gettext "PAID")" "$(eval_gettext '$GASH_HOME/Stall')"/* | wc -l)
