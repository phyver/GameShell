p=$(ps | grep "gros_minet.sh$" | sed 's/^ *//' | cut -f1 -d" ")
ps -o pid,comm,ppid | grep "$p$" | grep "generator" | sed 's/^ *//' | cut -f1 -d" " | xargs kill
rm "$(eval_gettext '$GASH_HOME/Castle/Cellar')"/.*_"$(gettext "cat")"
unset p
gash check

