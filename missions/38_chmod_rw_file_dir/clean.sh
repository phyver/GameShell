#!/bin/bash

# avoid problems when making a tar archive
safe="$(eval_gettext '$GASH_HOME/Castle/Main_building/Throne_room')/$(gettext "Safe")"
mkdir -p "$safe"
chmod 755 "$safe"
chmod -f 644 "$safe/$(gettext "crown")"
unset safe
