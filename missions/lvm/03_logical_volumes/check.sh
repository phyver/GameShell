#!/usr/bin/env sh

source "$MISSION_DIR/../00_shared/utils.sh"

_mission_check() (
  
  # Check that the logical volumes exist with the correct sizes
  if ! check_lv_size esdea/ouskelcoule 30; then
    echo "$(eval_gettext "The village of Ouskelcoule is not present or does not have the correct size (30 MB).")"
    return 1
  fi

  if ! check_lv_size esdea/douskelpar 20; then
    echo "$(eval_gettext "The village of Douskelpar is not present or does not have the correct size (20 MB).")"
    return 1
  fi

  if ! check_lv_size esdebe/grandflac 25; then
    echo "$(eval_gettext "The village of Grandflac is not present or does not have the correct size (25 MB).")"
    return 1
  fi

  echo "$(eval_gettext "Bravo, the borders of the villages of Ouskelcoule, Douskelpar and Grandflac are now drawn!")"
  return 0
)

_mission_check
