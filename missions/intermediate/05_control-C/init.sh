#!/usr/bin/env sh

_mission_init() {
  # nb of tries to make
  echo $((3 + $(RANDOM) % 3)) > "$GSH_TMP/control-C"

  cp "$MISSION_DIR/charmiglio.sh" "$GSH_BIN/$(gettext charmiglio)"
  chmod +x "$GSH_BIN/$(gettext charmiglio)"
}
_mission_init
