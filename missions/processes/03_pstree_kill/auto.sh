kill_imp_spell() {
  pstree -p $$
  local p=$(ps -ce | grep "$(gettext "mischievous_imp")" | awk '{print $1}')
  echo p=$p
  echo ps -ce -o pid,comm,ppid
  ps -ce -o pid,comm,ppid
  ps -ceo pid,comm,ppid | grep "$p$" | grep "$(gettext "spell")" | awk '{print $1}' | xargs kill -9 2>/dev/null
  ps -eo pid,comm,ppid | grep "$p$" | grep "$(gettext "spell")" | awk '{print $1}' | xargs kill -9 2>/dev/null
  pstree -p $$
}
cellar=$(eval_gettext '$GSH_HOME/Castle/Cellar')


kill_imp_spell
rm -f "$cellar"/*_"$(gettext "coal")"
gsh check

unset -f kill_imp_spell
unset cellar
