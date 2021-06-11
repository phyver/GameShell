#!/bin/sh

set +o noglob
rm -f "$GSH_TMP/start_time"

case $GSH_LAST_ACTION in
  check_true)
    ;;
  *)
    case "$(pwd)" in
      "$(eval_gettext '$GSH_HOME/Castle/Cellar')/.$(gettext "Lair_of_the_spider_queen")"*)
        cd "$(eval_gettext '$GSH_HOME/Castle/Cellar')"
        echo "$(gettext "You are back in the cellar.")"
        ;;
    esac
    rm -rf "$(eval_gettext '$GSH_HOME/Castle/Cellar')/.$(gettext "Lair_of_the_spider_queen")"*
    ;;
esac


