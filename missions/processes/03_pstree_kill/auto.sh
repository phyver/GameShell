kill_imp_spell() {
  local p=$(ps -c | grep "$(gettext "mischievous_imp")" | awk '{print $1}')
  ps -o pid,comm,ppid | grep "$p$" | grep "$(gettext "spell")" | awk '{print $1}' | xargs kill -9
}
cellar=$(eval_gettext '$GSH_HOME/Castle/Cellar')


kill_imp_spell
rm -f "$cellar"/*_"$(gettext "coal")"
gsh check

unset -f kill_imp_spell
unset cellar

