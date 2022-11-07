#!/usr/bin/env sh

rm "$(eval_gettext '$GSH_HOME/Castle/Cellar')/$(gettext "spider")"_?
gsh check
