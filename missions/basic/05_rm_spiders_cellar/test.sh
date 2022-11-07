#!/usr/bin/env sh

gsh assert check false

rm "$(eval_gettext '$GSH_HOME/Castle/Cellar')"/*
gsh assert check false

rm "$(eval_gettext '$GSH_HOME/Castle/Cellar')/$(gettext "spider")"_?
gsh assert check true

rm "$(eval_gettext '$GSH_HOME/Castle/Cellar')/$(gettext "spider")"_?
rm "$(eval_gettext '$GSH_HOME/Castle/Cellar')/$(gettext "bat")"_1
gsh assert check false
