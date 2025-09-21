#!/usr/bin/env sh

source "$MISSION_DIR/../00_shared/utils.sh"

_mission_check() (
  
  # Check that the logical volumes exist with the correct sizes
  if ! check_lv_size esdea/ouskelcoule 30; then
    echo "$(eval_gettext "Le village d'Ouskelcoule n'est pas présent ou n'a pas la bonne taille (30 Mo).")"
    return 1
  fi

  if ! check_lv_size esdea/douskelpar 20; then
    echo "$(eval_gettext "Le village de Douskelpar n'est pas présent ou n'a pas la bonne taille (20 Mo).")"
    return 1
  fi

  if ! check_lv_size esdebe/grandflac 25; then
    echo "$(eval_gettext "Le village de Grandflac n'est pas présent ou n'a pas la bonne taille (25 Mo).")"
    return 1
  fi

  echo "$(eval_gettext "Bravo, les frontières des villages d'Ouskelcoule, de Douskelpar et de Grandflac sont désormais tracées !")"
  return 0
)

_mission_check
