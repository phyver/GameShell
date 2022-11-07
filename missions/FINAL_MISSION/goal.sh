#!/usr/bin/env sh

export password=$(gettext "qwerty")
checksum "$password" > "$GSH_CONFIG/admin_hash"
sed "s/\\\$password/$password/g" "$(eval_gettext '$MISSION_DIR/goal/en.txt')"
unset password

