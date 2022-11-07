#!/usr/bin/env sh

rm -f "$(eval_gettext '$GSH_HOME/Castle/Cellar')/"*_"$(gettext "spider")"_*
gsh check
