kill_skinner_gen() {
    p=$(ps | grep "skinner.sh$" | sed 's/^ *//' | cut -f1 -d" ")
    ps -o pid,comm,ppid | grep "$p$" | grep "generator" | sed 's/^ *//' | cut -f1 -d" " | xargs kill
}
kitchen=$(eval_gettext '$GASH_HOME/Castle/Kitchen')


sleep 2
kill_skinner_gen
rm -f "$kitchen"/.*_"$(gettext "rat_poison")"
rm -f "$kitchen"/*_"$(gettext "rat_poison")"
gash assert_check true

sleep 4
kill_skinner_gen
rm -f "$kitchen"/*_"$(gettext "rat_poison")"
gash assert_check false

sleep 3
kill_skinner_gen
rm -f "$kitchen"/.*_"$(gettext "rat_poison")"
gash assert_check false

sleep 3
kill_skinner_gen
rm -f "$kitchen"/.*_"$(gettext "rat_poison")"
rm -f "$kitchen"/*_"$(gettext "rat_poison")"
rm -f "$kitchen"/*_"$(gettext "cheese")"
gash assert_check false


unset -f kill_skinner_gen
unset p kitchen

