cd "$(eval_gettext '$GASH_HOME/Stall')"
gash check < <(grep "$(gettext "the King") " * | grep -v "$(gettext "PAID")" | grep -o "[0-9]* [^0-9]*$" | awk '{s+=$1} END{print s}')
