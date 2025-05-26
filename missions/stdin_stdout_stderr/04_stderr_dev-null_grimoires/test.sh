#!/usr/bin/env sh

. alt_history_start.sh

cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Library/Merlin_s_office')"

add_cmd 'grep -i gsh "$(gettext "grimoire")"_*'
add_cmd 'gsh check'
gsh assert check false

add_cmd 'grep -il gsh "$(gettext "grimoire")"_*'
add_cmd 'gsh check'
gsh assert check false

chmod a+r "$(gettext "grimoire")"_*
add_cmd 'grep -il gsh "$(gettext "grimoire")"_*'
add_cmd 'gsh check'
gsh assert check false

add_cmd 'grep -il gsh "$(gettext "grimoire")"_* 2>/dev/null'
add_cmd 'gsh check'
gsh assert check true

. alt_history_stop.sh
