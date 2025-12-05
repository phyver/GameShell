#!/usr/bin/env sh

source "$MISSION_DIR/../00_shared/utils.sh"

_mission_check() (
  
  # Check that the logical volumes exist with the correct sizes
  if ! check_lv_size esdea/ouskelcoule 40; then
    echo "$(eval_gettext "The borders of the village of Ouskelcoule should be 40 Mornifles!")"
    return 1
  fi

  if ! check_lv_size esdea/douskelpar 10; then
    echo "$(eval_gettext "The borders of the village of Douskelpar should be 10 Mornifles!")"
    return 1
  fi

  echo "$(eval_gettext "Bravo, the borders of the villages of Ouskelcoule and Douskelpar have been well adapted to the realities of the terrain!")"
  return 0
)

_mission_check