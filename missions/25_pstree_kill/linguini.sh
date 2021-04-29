#!/bin/bash

source gettext.sh

"$MISSION_DIR"/generator "$(eval_gettext '$GASH_HOME/Castle/Kitchen')" "$(gettext "cheese")" &
disown
sleep 1
"$MISSION_DIR"/generator "$(eval_gettext '$GASH_HOME/Castle/Kitchen')" "$(gettext "cheese")" &
disown
sleep 1
"$MISSION_DIR"/generator "$(eval_gettext '$GASH_HOME/Castle/Kitchen')" "$(gettext "cheese")" &
disown

trap "" SIGTERM SIGINT
tail -f /dev/null
