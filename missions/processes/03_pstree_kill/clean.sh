#!/bin/sh

my_ps | awk -v spell="$(gettext "spell")" '$0 ~ spell {print $1}' | xargs kill -9 2>/dev/null
my_ps | awk -v imp="$(gettext "mischievous_imp")" '$0 ~ imp {print $1}' | xargs kill -9 2>/dev/null
my_ps | awk -v fairy="$(gettext "nice_fairy")" '$0 ~ fairy {print $1}' | xargs kill -9 2>/dev/null
my_ps | awk '$0 ~ /sleep|tail/ {print $1}' | xargs kill -9 2>/dev/null
rm -rf "$GSH_TMP/fairy" "$GSH_TMP/imp"
rm -f "$GSH_TMP/snowflakes.list"
rm -f "$GSH_TMP/coals.list"
rm -f "$GSH_TMP/snowflakes-generated"
rm -f "$GSH_TMP/snowflakes-present"
rm -f "$GSH_TMP/fairy_spell.pids"
rm -f "$GSH_TMP/imp_spell.pids"
rm -f "$GSH_TMP/fairy.pid"
rm -f "$GSH_TMP/imp.pid"
rm -f "$GSH_TMP/$(gettext "nice_fairy")"
rm -f "$GSH_TMP/$(gettext "mischievous_imp")"
(
  cd "$(eval_gettext '$GSH_HOME/Castle/Cellar')"
  # keep at most 10 snowflakes
  find . -name "*_$(gettext "snowflake")" | sed '1,10d' | xargs rm -f
  find . -name "*_$(gettext "coal")" | xargs rm -f
)
[ -n "$GSH_NON_INTERACTIVE" ] || set -o monitor  # monitor background processes (default)
