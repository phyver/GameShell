#!/bin/bash

source gettext.sh

"$MISSION_DIR"/generator "$(eval_gettext '$GASH_HOME/Castle/Kitchen')" "$(gettext "rat_poison")" &
disown
sleep 1
"$MISSION_DIR"/generator "$(eval_gettext '$GASH_HOME/Castle/Kitchen')" "$(gettext "rat_poison")" &
disown
sleep 1
"$MISSION_DIR"/generator "$(eval_gettext '$GASH_HOME/Castle/Kitchen')" "$(gettext "rat_poison")" &
disown

trap "" SIGTERM SIGINT
tail -f /dev/null
