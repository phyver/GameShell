#!/bin/bash

source gettext.sh

if [ -x /usr/bin/python3 ]
then
    "$GASH_LOCAL_BIN"/generator.py "$(eval_gettext '$GASH_HOME/Castle/Cellar')" "$(gettext "cheese")" &
    disown
    "$GASH_LOCAL_BIN"/generator.py  "$(eval_gettext '$GASH_HOME/Castle/Cellar')" "$(gettext "cheese")" &
    disown
    "$GASH_LOCAL_BIN"/generator.py  "$(eval_gettext '$GASH_HOME/Castle/Cellar')" "$(gettext "cheese")" &
    disown
else
    "$GASH_LOCAL_BIN"/generator.sh "$(eval_gettext '$GASH_HOME/Castle/Cellar')" "$(gettext "cheese")" &
    disown
    "$GASH_LOCAL_BIN"/generator.sh  "$(eval_gettext '$GASH_HOME/Castle/Cellar')" "$(gettext "cheese")" &
    disown
    "$GASH_LOCAL_BIN"/generator.sh  "$(eval_gettext '$GASH_HOME/Castle/Cellar')" "$(gettext "cheese")" &
    disown
fi

trap "" SIGTERM SIGINT
tail -f /dev/null
