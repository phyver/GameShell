#!/usr/bin/env sh

trap 'rm -f "$GSH_TMP/test-proc-name"' EXIT

# use a subshell, that should guarantee that no message is displayed when the
# test-proc-name process is killed.
_mission_init() (

  # make sure the shebang for the test-proc-name.sh script is a real path to sh
  # otherwise, ps will not use the filename as the process name...
  sh=$(command -v sh)

  # no need for copy_bin
  echo "#! $sh" > "$GSH_TMP/test-proc-name"
  cat "$MISSION_DIR/test-proc-name.sh" >> "$GSH_TMP/test-proc-name"
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
(Debian / Ubuntu: install package 'procps')")"
    return 1
  fi
  return 0
)

_mission_init
