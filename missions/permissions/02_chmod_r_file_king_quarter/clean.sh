#!/bin/sh

# avoid problems when making a tar archive
chmod +r "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room/Kings_quarter')/.$(gettext "secret_note")"
rm -f "$GSH_TMP/key"

