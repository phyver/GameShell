#!/bin/bash

safe="$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')/$(gettext "Safe")"
chmod 755 "$safe"
chmod 644 "$safe/$(gettext "crown")"
mv "$safe/$(gettext "crown")" $GSH_CHEST

key=$(tail -n 1 "$GSH_CHEST/$(gettext "crown")" | cut -c 4-6)

gsh check < <(echo $key)

unset safe key
