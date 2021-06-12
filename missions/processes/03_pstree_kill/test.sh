#!/bin/sh

kill_imp_spell() (
  p=$(COLUMNS=512 ps -cA | grep "$(gettext "mischievous_imp")" | awk '{print $1}')
  # argh, ps -eo ... doesn't find any process in macos-latest
  # and   ps -cAo ... doesn't find any process in ubuntu-latest
  # let's try both!
  COLUMNS=512 ps -cAo pid,comm,ppid 2>/dev/null | grep "$p$" | grep "$(gettext "spell")" | awk '{print $1}' | xargs kill -9 2>/dev/null
  COLUMNS=512 ps -eo pid,comm,ppid | grep "$p$" | grep "$(gettext "spell")" | awk '{print $1}' | xargs kill -9 2>/dev/null
)
cellar=$(eval_gettext '$GSH_HOME/Castle/Cellar')

stand_by() (
  nl=""
  while ! [ -e "$GSH_VAR/snowflakes.list" ] || ! [ -e "$GSH_VAR/coals.list" ]
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

