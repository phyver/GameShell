#!/usr/bin/env sh

source "$MISSION_DIR/../00_shared/utils.sh"

_mission_check() (
  
  # Check that the logical volumes exist with the correct sizes
  if ! check_lv_size esdea/ouskelcoule 40; then
    echo "$(eval_gettext "Les frontières du village d'Ouskelcoule devraient faire 40 Mornifles !")"
    return 1
  fi

  if ! check_lv_size esdea/douskelpar 10; then
    echo "$(eval_gettext "Les frontières du village de Douskelpar devraient faire 10 Mornifles !")"
    return 1
  fi

  echo "$(eval_gettext "Bravo, les frontières des villages d'Ouskelcoule, de Douskelpar ont bien été adaptées aux réalités du terrain !")"
  return 0
)

_mission_check