#!/bin/bash

if [ -x /usr/bin/python3 ]
then
    "$GASH_LOCAL_BIN/cat-generator" "$(eval_gettext '$GASH_HOME/Castle/Cellar')" "$(gettext "cat")" &
    disown
else
    "$GASH_LOCAL_BIN/cat_generator" "$(eval_gettext '$GASH_HOME/Castle/Cellar')" "$(gettext "cat")" &
    disown
fi
