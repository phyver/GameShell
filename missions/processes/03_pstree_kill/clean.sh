disown "$(cat "$GSH_VAR/fairy.pid")" "$(cat "$GSH_VAR/imp.pid")"
ps -e | awk -v spell="$(gettext "spell")" '$0 ~ spell {print $1}' | xargs kill -9 &> /dev/null
ps -e | awk -v imp="$(gettext "mischievous_imp")" '$0 ~ imp {print $1}' | xargs kill -9 &> /dev/null
ps -e | awk -v fairy="$(gettext "nice_fairy")" '$0 ~ fairy {print $1}' | xargs kill -9 &> /dev/null
ps | awk '$0 ~ /sleep|tail/ {print $1}' | xargs kill -9 &> /dev/null
rm -rf "$GSH_VAR/fairy" "$GSH_VAR/imp"
rm -f "$GSH_VAR/snowflakes-"{0,1,2}.list
rm -f "$GSH_VAR/snowflakes-"{generated,present}
rm -f "$GSH_VAR"/{fairy_spell,imp_spell}.pids
rm -f "$GSH_VAR"/{fairy,imp}.pid
rm -f "$GSH_VAR"/{fairy,imp}.pid
rm -f "$GSH_VAR/$(gettext "nice_fairy")"
rm -f "$GSH_VAR/$(gettext "mischievous_imp")"
