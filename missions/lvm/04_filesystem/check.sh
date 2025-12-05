#!/usr/bin/env sh

source "$MISSION_DIR/../00_shared/utils.sh"

_mission_check() (

  # Ouskelcoule (esdea/ouskelcoule) must be EXT4
  if ! check_lv_fs_type esdea/ouskelcoule ext4; then
    case $? in
      2) echo "$(eval_gettext "The village of Ouskelcoule does not exist (LV /dev/esdea/ouskelcoule not found).")";;
      3) echo "$(eval_gettext "The village of Ouskelcoule is not yet organized (no filesystem).")";;
      *) echo "$(eval_gettext "The village of Ouskelcoule is not in EXT4 format.")";;
    esac
    return 1
  fi

  # Douskelpar (esdea/douskelpar) must be EXT4
  if ! check_lv_fs_type esdea/douskelpar ext4; then
    case $? in
      2) echo "$(eval_gettext "The village of Douskelpar does not exist (LV /dev/esdea/douskelpar not found).")";;
      3) echo "$(eval_gettext "The village of Douskelpar is not yet organized (no filesystem).")";;
      *) echo "$(eval_gettext "The village of Douskelpar is not in EXT4 format.")";;
    esac
    return 1
  fi

  # Grandflac (esdebe/grandflac) must be EXT4
  if ! check_lv_fs_type esdebe/grandflac ext4; then
    case $? in
      2) echo "$(eval_gettext "The village of Grandflac does not exist (LV /dev/esdebe/grandflac not found).")";;
      3) echo "$(eval_gettext "The village of Grandflac is not yet organized (no filesystem).")";;
      *) echo "$(eval_gettext "The village of Grandflac is not in EXT4 format.")";;
    esac
    return 1
  fi

  echo "$(eval_gettext "Bravo! Ouskelcoule, Douskelpar and Grandflac are duly organized and partitioned, almost ready to welcome their inhabitants!")"
  return 0
)

_mission_check
