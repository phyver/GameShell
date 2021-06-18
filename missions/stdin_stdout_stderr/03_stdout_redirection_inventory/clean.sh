#!/bin/sh

rm -f "$GSH_TMP/inventory_grimoires"
(
  cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Library/Merlin_s_office')"
  chmod +r "$(gettext "grimoire")_"*
)

