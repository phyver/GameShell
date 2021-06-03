ps -ec | awk -v spell="$(gettext "spell")" '$0 ~ spell {print $1}' | xargs kill -9 &> /dev/null
ps -ec | awk -v imp="$(gettext "mischievous_imp")" '$0 ~ imp {print $1}' | xargs kill -9 &> /dev/null
ps -ec | awk -v fairy="$(gettext "nice_fairy")" '$0 ~ fairy {print $1}' | xargs kill -9 &> /dev/null
ps -ec | awk '$0 ~ /sleep|tail/ {print $1}' | xargs kill -9 &> /dev/null
rm -rf "$GSH_VAR/fairy" "$GSH_VAR/imp"
rm -f "$GSH_VAR/snowflakes.list"
rm -f "$GSH_VAR/coals.list"
rm -f "$GSH_VAR/snowflakes-"{generated,present}
rm -f "$GSH_VAR"/{fairy_spell,imp_spell}.pids
rm -f "$GSH_VAR"/{fairy,imp}.pid
rm -f "$GSH_VAR"/{fairy,imp}.pid
rm -f "$GSH_VAR/$(gettext "nice_fairy")"
rm -f "$GSH_VAR/$(gettext "mischievous_imp")"
(
  cd "$(eval_gettext '$GSH_HOME/Castle/Cellar')"
  # keep at most 10 snowflakes
  find . -name "*_$(gettext "snowflake")" | sed '1,10d' | xargs rm -f
  find . -name "*_$(gettext "coal")" | xargs rm -f
)
