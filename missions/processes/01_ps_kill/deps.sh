_mission_deps() (
  cp "$MISSION_DIR/test-proc-name.sh" "$GSH_VAR/test-proc-name"
  chmod +x "$GSH_VAR/test-proc-name"
  "$GSH_VAR/test-proc-name" &
  PID=$!
  ps | grep "\b$PID\b" | grep -v bash &> /dev/null
  local r=$?
  kill -9 "$PID" &> /dev/null
  rm -f "$GSH_VAR/test-proc-name"
  return $r
)

if ! _mission_deps
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
