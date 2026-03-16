#!/usr/bin/env sh


_mission_init() {
    spell=$(gettext "glowing_finger.spl")
    cp "$MISSION_DIR/glowing_finger.spl" "$(eval_gettext '$GSH_HOME/Castle/Library')/$spell"
}
_mission_init
