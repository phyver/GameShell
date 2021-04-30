p=$(ps | grep "skinner.sh$" | sed 's/^ *//' | cut -f1 -d" ")
ps -o pid,comm,ppid | grep "$p$" | grep "generator" | sed 's/^ *//' | cut -f1 -d" " | xargs kill
rm -f "$(eval_gettext '$GASH_HOME/Castle/Kitchen')"/.*_"$(gettext "rat_poison")"
rm -f "$(eval_gettext '$GASH_HOME/Castle/Kitchen')"/*_"$(gettext "rat_poison")"
unset p
gash check

