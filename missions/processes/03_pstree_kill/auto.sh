kill_imp_spell() {
    local p=$(ps | grep "$(gettext "mischievous_imp")" | sed 's/^ *//' | cut -f1 -d" ")
    ps -o pid,comm,ppid | grep "$p$" | grep "$(gettext "spell")" | sed 's/^ *//' | cut -f1 -d" " | xargs kill
}
cellar=$(eval_gettext '$GSH_HOME/Castle/Cellar')


kill_imp_spell
rm -f "$cellar"/*_"$(gettext "coal")"
gsh check

unset -f kill_imp_spell
unset cellar

