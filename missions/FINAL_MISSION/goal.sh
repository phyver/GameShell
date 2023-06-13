#!/usr/bin/env sh

ADMIN_PASSWD=$(gettext "qwerty")

ADMIN_SALT=$("$GSH_ROOT"/scripts/random_string)
ADMIN_HASH=$(checksum "$ADMIN_SALT $ADMIN_PASSWD")

echo "$ADMIN_SALT" > "$GSH_CONFIG/admin_salt"
echo "$ADMIN_HASH" > "$GSH_CONFIG/admin_hash"

sed "s/\\\$password/$ADMIN_PASSWD/g" "$(eval_gettext '$MISSION_DIR/goal/en.txt')"
unset ADMIN_PASSWD ADMIN_SALT ADMIN_HASH
