kill_imp_spell() {
  local p=$(ps -ce | grep "$(gettext "mischievous_imp")" | awk '{print $1}')
  ps -ceo pid,comm,ppid | grep "$p$" | grep "$(gettext "spell")" | awk '{print $1}' | xargs kill -9
}
cellar=$(eval_gettext '$GSH_HOME/Castle/Cellar')

stand_by() {
  local nl=""
  while ! [ -e "$GSH_VAR/snowflakes.list" ] || ! [ -e "$GSH_VAR/coals.list" ]
  do
    sleep 0.5
    printf "."
    nl="\n"
  done
  printf "$nl"
}

stand_by
kill_imp_spell
rm -f "$cellar"/*_"$(gettext "coal")"
gsh assert_check true

stand_by
kill_imp_spell
gsh assert_check false

stand_by
kill_imp_spell
rm -f "$cellar"/*_"$(gettext "coal")"
rm -f "$cellar"/*_"$(gettext "snowflake")"
gsh assert_check false


unset -f kill_imp_spell
unset p cellar

