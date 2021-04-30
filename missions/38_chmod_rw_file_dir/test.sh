#!/bin/bash


gash assert check false

touch "$GASH_CHEST/$(gettext "crown")"
gash assert check false

safe_dir="$(eval_gettext '$GASH_HOME/Castle/Main_building/Throne_room')/$(gettext "Safe")"
chmod 755 "$safe_dir"
mv "$safe_dir/$(gettext "crown")" $GASH_CHEST
gash assert check false

safe_dir="$(eval_gettext '$GASH_HOME/Castle/Main_building/Throne_room')/$(gettext "Safe")"
chmod 755 "$safe_dir"
chmod 644 "$safe_dir/$(gettext "crown")"
mv -f "$safe_dir/$(gettext "crown")" $GASH_CHEST
gash assert check false < <(echo "1234")

safe_dir="$(eval_gettext '$GASH_HOME/Castle/Main_building/Throne_room')/$(gettext "Safe")"
chmod 755 "$safe_dir"
chmod 644 "$safe_dir/$(gettext "crown")"
mv -f "$safe_dir/$(gettext "crown")" $GASH_CHEST
key=$(tail -n 1 "$GASH_CHEST/$(gettext "crown")" | cut -c 4-6)
gash assert check true < <(echo "$key")

unset safe_dir key
