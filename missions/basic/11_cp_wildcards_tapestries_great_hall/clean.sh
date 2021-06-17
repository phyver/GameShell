#!/bin/sh

mission_source "$MISSION_DIR"/clean0.sh

rm -f "$GSH_TMP/great_hall_contents"

case "$GSH_LAST_ACTION" in
  check_true | skip)
    :
    ;;
  *)
    great_hall=$(eval_gettext '$GSH_HOME/Castle/Great_hall')
    rm -f "$great_hall"/*"$(gettext "tapestry")"*
    rm -f "$GSH_CHEST"/*"$(gettext "tapestry")"*
    unset great_hall
    ;;
esac

