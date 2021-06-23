#!/bin/sh

. history_start.sh

cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Library/Merlin_s_office')"

add_cmd 'grep -il "gsh" "$(gettext "grimoire")"_* 2> /dev/null'
grep -il "gsh" "$(gettext "grimoire")"_* 2> /dev/null
add_cmd gsh check
gsh check

. history_clean.sh
