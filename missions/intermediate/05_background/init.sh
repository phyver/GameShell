#!/usr/bin/env sh

_mission_init() {
  copy_bin "$MISSION_DIR/charmiglio.sh" "$GSH_BIN/$(gettext charmiglio)"
}
_mission_init
