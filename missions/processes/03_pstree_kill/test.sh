kill_imp_spell() {
    p=$(ps | grep "$(gettext "mischievous_imp")" | sed 's/^ *//' | cut -f1 -d" ")
    ps -o pid,comm,ppid | grep "$p$" | grep "$(gettext "spell")" | sed 's/^ *//' | cut -f1 -d" " | xargs kill
}
cellar=$(eval_gettext '$GSH_HOME/Castle/Cellar')


sleep 2
kill_imp_spell
rm -f "$cellar"/*_"$(gettext "coal")"
gsh assert_check true

sleep 2
kill_imp_spell
gsh assert_check false

sleep 2
kill_imp_spell
rm -f "$cellar"/*_"$(gettext "coal")"
rm -f "$cellar"/*_"$(gettext "snowflake")"
gsh assert_check false


unset -f kill_imp_spell
unset p cellar

