#!/bin/bash


gsh assert check false

touch "$GSH_CHEST/$(gettext "crown")"
gsh assert check false

safe_dir="$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')/$(gettext "Safe")"
chmod 755 "$safe_dir"
mv "$safe_dir/$(gettext "crown")" $GSH_CHEST
gsh assert check false

safe_dir="$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')/$(gettext "Safe")"
chmod 755 "$safe_dir"
chmod 644 "$safe_dir/$(gettext "crown")"
mv -f "$safe_dir/$(gettext "crown")" $GSH_CHEST
gsh assert check false < <(echo "1234")

safe_dir="$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')/$(gettext "Safe")"
chmod 755 "$safe_dir"
chmod 644 "$safe_dir/$(gettext "crown")"
mv -f "$safe_dir/$(gettext "crown")" $GSH_CHEST
key=$(tail -n 1 "$GSH_CHEST/$(gettext "crown")" | cut -c 4-6)
gsh assert check true < <(echo "$key")

unset safe_dir key
