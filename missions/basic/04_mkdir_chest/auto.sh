#!/bin/sh

mkdir -p "$(eval_gettext "\$GSH_HOME/Forest")/$(gettext "Hut")/$(gettext "Chest")"
gsh check
