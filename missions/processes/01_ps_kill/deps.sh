BASH=$(command -v bash)
sed -e $'1c\\\n'"#!$BASH" "$MISSION_DIR/test-proc-name.sh" > "$GSH_VAR/test-proc-name"
chmod 755 "$GSH_VAR/test-proc-name"
"$GSH_VAR/test-proc-name" &
PID=$!
disown "$PID"
if ! ps | grep "\b$PID\b" | grep -v bash &> /dev/null
then
    kill -9 "$PID" &> /dev/null
    echo "$(eval_gettext "Process names should be equal to the corresponding filename for mission \$MISSION_NAME.")"
    false
elif ! command -v ps &> /dev/null
then
    kill -9 "$PID"
    echo "$(eval_gettext "The command 'ps' is required for mission \$MISSION_NAME.
(Debian / Ubuntu: install package 'psproc')")"
    false
fi
