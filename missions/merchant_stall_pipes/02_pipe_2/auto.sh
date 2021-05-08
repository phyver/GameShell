gsh check < <(grep -v "$(gettext "PAID")" "$(eval_gettext '$GSH_HOME/Stall')"/* | wc -l)
