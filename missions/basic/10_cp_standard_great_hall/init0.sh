#!/bin/sh

_mission_init0() (
  great_hall="$(eval_gettext '$GSH_HOME/Castle/Great_hall')"

  rm -f "$great_hall/"*_"$(gettext "stag_head")"
  sign_file "$MISSION_DIR/ascii-art/stag_head.txt" "$great_hall/$(RANDOM)_$(gettext "stag_head")"
  rm -f "$great_hall/"*_"$(gettext "decorative_shield")"
  sign_file "$MISSION_DIR/ascii-art/shield.txt" "$great_hall/$(RANDOM)_$(gettext "decorative_shield")"
  rm -f "$great_hall/"*_"$(gettext "suit_of_armour")"
  sign_file "$MISSION_DIR/ascii-art/armour.txt" "$great_hall/$(RANDOM)_$(gettext "suit_of_armour")"
)
_mission_init0
unset -f _mission_init0
