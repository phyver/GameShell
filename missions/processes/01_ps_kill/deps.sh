# BASH=$(command -v bash)
# sed -e $'1c\\\n'"#!$BASH" "$MISSION_DIR/test-proc-name.sh" > "$GSH_VAR/test-proc-name"
# chmod 755 "$GSH_VAR/test-proc-name"
# "$GSH_VAR/test-proc-name" &
# PID=$!
# kill -9 "$PID"

if ! command -v ps &> /dev/null; then
    echo "$(eval_gettext "The command 'ps' is required for mission \$MISSION_NAME.
(Debian / Ubuntu: install package 'psproc')")"
    false
fi
