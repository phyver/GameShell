#!/bin/sh

. history_start.sh

cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Library/Merlin_s_office')"

add_cmd 'grep -il "gsh" "$(gettext "grimoire")"_* 2> /dev/null'
add_cmd gsh check

grep -il "gsh" "$(gettext "grimoire")"_* 2> /dev/null
gsh check

. history_clean.sh
