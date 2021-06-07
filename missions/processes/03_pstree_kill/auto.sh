kill_imp_spell() {
  local p=$(COLUMNS=512 ps -ce | grep "$(gettext "mischievous_imp")" | awk '{print $1}')
  # argh, ps -eo ... doesn't find any process in macos-latest
  # and   ps -ceo ... doesn't find any process in ubuntu-latest
  # let's try both!
  COLUMNS=512 ps -ceo pid,comm,ppid | grep "$p$" | grep "$(gettext "spell")" | awk '{print $1}' | xargs kill -9 2>/dev/null
  COLUMNS=512 ps -eo pid,comm,ppid | grep "$p$" | grep "$(gettext "spell")" | awk '{print $1}' | xargs kill -9 2>/dev/null
}
cellar=$(eval_gettext '$GSH_HOME/Castle/Cellar')


kill_imp_spell
rm -f "$cellar"/*_"$(gettext "coal")"
gsh check

unset -f kill_imp_spell
unset cellar
