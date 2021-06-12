#!/bin/sh

export password=$(gettext "qwerty")
checksum "$password" > "$GSH_CONFIG/admin_hash"
envsubst '$password' < "$(eval_gettext '$MISSION_DIR/goal/en.txt')"
unset password

