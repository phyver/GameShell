#!/bin/bash

safedir="$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')/$(gettext "Safe")"
chmod 755 "$safedir"
chmod 644 "$safedir/$(gettext "crown")"
mv "$safedir/$(gettext "crown")" $GSH_CHEST

key=$(tail -n 1 "$GSH_CHEST/$(gettext "crown")" | cut -c 4-6)

gsh check < <(echo $key)

unset safedir key
