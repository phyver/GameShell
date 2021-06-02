kill_imp_spell() {
  local p=$(ps -c | grep "$(gettext "mischievous_imp")" | awk '{print $1}')
  ps -o pid,comm,ppid | grep "$p$" | grep "$(gettext "spell")" | awk '{print $1}' | xargs kill -9
}
cellar=$(eval_gettext '$GSH_HOME/Castle/Cellar')


sleep 5
kill_imp_spell
rm -f "$cellar"/*_"$(gettext "coal")"
gsh assert_check true

sleep 5
kill_imp_spell
gsh assert_check false

sleep 5
kill_imp_spell
rm -f "$cellar"/*_"$(gettext "coal")"
rm -f "$cellar"/*_"$(gettext "snowflake")"
gsh assert_check false


unset -f kill_imp_spell
unset p cellar

