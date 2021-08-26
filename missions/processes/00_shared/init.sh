#!/bin/sh

# use a subshell, that should guarantee that no message is displayed when the
# test-proc-name process is killed.
_mission_init() (
  cp "$MISSION_DIR/test-proc-name.sh" "$GSH_TMP/test-proc-name"
  chmod +x "$GSH_TMP/test-proc-name"
  "$GSH_TMP/test-proc-name" &
  PID=$!
  name=$(my_ps $PID | grep $PID | grep -v sh | grep "test-proc-name")
  kill -9 $PID
  if [ -z "$name" ]
  then
    echo "$(eval_gettext "Process names should be equal to the corresponding filename for mission \$MISSION_NAME.")" >&2
    return 1
  elif ! command -v ps >/dev/null
  then
    echo "$(eval_gettext "The command 'ps' is required for mission \$MISSION_NAME.
(Debian / Ubuntu: install package 'psproc')")"
    return 1
  fi
  return 0
)

_mission_init
