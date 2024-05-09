#!/usr/bin/env sh

_mission_init() {
  # nb of tries to make
  echo $((2 + $(RANDOM) % 3)) > "$GSH_TMP/control-C"
  rm -f "$GSH_TMP/control-C.codes"

  copy_bin "$MISSION_DIR/Charmiglio.sh" "$GSH_BIN/$(gettext Charmiglio)"
}
_mission_init
