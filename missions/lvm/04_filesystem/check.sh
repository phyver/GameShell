#!/usr/bin/env sh

_mission_check() (

  # Helper: check filesystem type of a logical volume
  check_lv_fs_type() {
    lv_path="$1"          # e.g. esdea/ouskelcoule
    expected="$2"         # e.g. ext4

    # Read filesystem TYPE via blkid (empty if unformatted)
    fstype="$(blkid -o value -s TYPE "$dev" 2>"$GSH_HOME/dev/null")"
    if [ -z "$fstype" ]; then
      return 3  # special code: no filesystem
    fi

    # Match expected type
    if [ "$fstype" = "$expected" ]; then
      return 0
    else
      return 1
    fi
  }

  # Ouskelcoule (esdea/ouskelcoule) must be EXT4
  if ! check_lv_fs_type esdea/ouskelcoule ext4; then
    case $? in
      2) echo "$(eval_gettext "Le village d'Ouskelcoule n'existe pas (LV $GSH_HOME/dev/esdea/ouskelcoule introuvable).")";;
      3) echo "$(eval_gettext "Le village d'Ouskelcoule n'est pas encore organisé (aucun système de fichiers).")";;
      *) echo "$(eval_gettext "Le village d'Ouskelcoule n'est pas au format EXT4.")";;
    esac
    return 1
  fi

  # Douskelpar (esdea/douskelpar) must be EXT4
  if ! check_lv_fs_type esdea/douskelpar ext4; then
    case $? in
      2) echo "$(eval_gettext "Le village de Douskelpar n'existe pas (LV $GSH_HOME/dev/esdea/douskelpar introuvable).")";;
      3) echo "$(eval_gettext "Le village de Douskelpar n'est pas encore organisé (aucun système de fichiers).")";;
      *) echo "$(eval_gettext "Le village de Douskelpar n'est pas au format EXT4.")";;
    esac
    return 1
  fi

  # Grandflac (esdebe/grandflac) must be EXT4
  if ! check_lv_fs_type esdebe/grandflac ext4; then
    case $? in
      2) echo "$(eval_gettext "Le village de Grandflac n'existe pas (LV $GSH_HOME/dev/esdebe/grandflac introuvable).")";;
      3) echo "$(eval_gettext "Le village de Grandflac n'est pas encore organisé (aucun système de fichiers).")"
      *) echo "$(eval_gettext "Le village de Grandflac n'est pas au format EXT4.")";;
    esac
    return 1
  fi

  echo "$(eval_gettext "Bravo ! Ouskelcoule, Douskelpar et Grandflac sont dûment organisés et découpés, presque prêts à accueillir leurs habitants !")"
  return 0
)

_mission_check
