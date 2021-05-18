_mission_test() {
  local BASH_PATH=$(command -v bash)
  sed -e $'1c\\\n'"#!$BASH_PATH" "$MISSION_DIR/test-proc-name.sh" > "$GSH_VAR/test-proc-name"
  chmod 755 "$GSH_VAR/test-proc-name"
  "$GSH_VAR/test-proc-name" &
  local PID=$!
  disown $PID
  ps | grep "\b$PID\b" | grep -v bash &> /dev/null
  local r=$?
  kill -9 "$PID" &> /dev/null
  rm -f "$GSH_VAR/test-proc-name"
  return $r
}

if ! _mission_test
then
  echo "$(eval_gettext "Process names should be equal to the corresponding filename for mission \$MISSION_NAME.")"
  unset -f process_test
  false
elif ! command -v ps &> /dev/null
then
  echo "$(eval_gettext "The command 'ps' is required for mission \$MISSION_NAME.
  (Debian / Ubuntu: install package 'psproc')")"
  unset -f process_test
  false
fi
