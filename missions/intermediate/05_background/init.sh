#!/usr/bin/env sh

_mission_init() {
  copy_bin "$MISSION_DIR/flarigo.sh" "$GSH_BIN/$(gettext flarigo)"
}
_mission_init
