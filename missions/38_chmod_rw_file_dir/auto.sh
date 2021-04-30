#!/bin/bash

safe="$(eval_gettext '$GASH_HOME/Castle/Main_building/Throne_room')/$(gettext "Safe")"
chmod 755 "$safe"
chmod 644 "$safe/$(gettext "crown")"
mv "$safe/$(gettext "crown")" $GASH_CHEST

key=$(tail -n 1 "$GASH_CHEST/$(gettext "crown")" | cut -c 4-6)

gash check < <(echo $key)

unset safe key
