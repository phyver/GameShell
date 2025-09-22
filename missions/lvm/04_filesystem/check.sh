#!/usr/bin/env sh

source "$MISSION_DIR/../00_shared/utils.sh"

_mission_check() (

  # Ouskelcoule (esdea/ouskelcoule) must be EXT4
  if ! check_lv_fs_type esdea/ouskelcoule ext4; then
    case $? in
      2) echo "$(eval_gettext "Le village d'Ouskelcoule n'existe pas (LV /dev/esdea/ouskelcoule introuvable).")";;
      3) echo "$(eval_gettext "Le village d'Ouskelcoule n'est pas encore organisé (aucun système de fichiers).")";;
      *) echo "$(eval_gettext "Le village d'Ouskelcoule n'est pas au format EXT4.")";;
    esac
    return 1
  fi

  # Douskelpar (esdea/douskelpar) must be EXT4
  if ! check_lv_fs_type esdea/douskelpar ext4; then
    case $? in
      2) echo "$(eval_gettext "Le village de Douskelpar n'existe pas (LV /dev/esdea/douskelpar introuvable).")";;
      3) echo "$(eval_gettext "Le village de Douskelpar n'est pas encore organisé (aucun système de fichiers).")";;
      *) echo "$(eval_gettext "Le village de Douskelpar n'est pas au format EXT4.")";;
    esac
    return 1
  fi

  # Grandflac (esdebe/grandflac) must be EXT4
  if ! check_lv_fs_type esdebe/grandflac ext4; then
    case $? in
      2) echo "$(eval_gettext "Le village de Grandflac n'existe pas (LV /dev/esdebe/grandflac introuvable).")";;
      3) echo "$(eval_gettext "Le village de Grandflac n'est pas encore organisé (aucun système de fichiers).")";;
      *) echo "$(eval_gettext "Le village de Grandflac n'est pas au format EXT4.")";;
    esac
    return 1
  fi

  echo "$(eval_gettext "Bravo ! Ouskelcoule, Douskelpar et Grandflac sont dûment organisés et découpés, presque prêts à accueillir leurs habitants !")"
  return 0
)

_mission_check
