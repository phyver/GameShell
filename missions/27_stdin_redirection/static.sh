#!/bin/bash

mkdir -p "$(eval_gettext '$GASH_HOME/Castle/Main_building/Library')"

touch "$(eval_gettext '$GASH_HOME/Castle/Main_building/Library')/$(gettext "Mathematics_101")"

touch "$(eval_gettext '$GASH_HOME/Castle/Main_building/Library')/$(gettext "Greek_Latin_and_other_modern_languages")"
