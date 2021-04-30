p=$(ps | grep "skinner.sh$" | sed 's/^ *//' | cut -f1 -d" ")
( ps -o pid,comm,ppid | grep "$p$" | awk '/generator/ {print $1}' | xargs kill ) 2> /dev/null
rm -f "$(eval_gettext '$GASH_HOME/Castle/Kitchen')"/.*_"$(gettext "rat_poison")"
rm -f "$(eval_gettext '$GASH_HOME/Castle/Kitchen')"/*_"$(gettext "rat_poison")"

unset p
gash check

