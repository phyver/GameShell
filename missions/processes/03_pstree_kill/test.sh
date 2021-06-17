#!/bin/sh

kill_imp_spell() (
  p=$(my_ps | grep "$(gettext "mischievous_imp")" | awk '{print $1}')
  my_ps |
    awk -v PID="$p" -v spell="$(gettext "spell")" '($2 == PID) && ($3 ~ spell) {print $1}' |
    xargs kill -9 2>/dev/null
)
cellar=$(eval_gettext '$GSH_HOME/Castle/Cellar')

stand_by() (
  nl=""
  while ! [ -e "$GSH_TMP/snowflakes.list" ] || ! [ -e "$GSH_TMP/coals.list" ]
  do
    sleep 0.5
    printf "."
    nl='\n'
  done
  printf "$nl"
)

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

