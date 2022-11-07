#!/usr/bin/env sh

case "$GSH_LAST_ACTION" in
    "check_true")
        ;;
    *)
        find "$GSH_HOME" -name ".*_$(gettext "coin")_*" -type f -print0 | xargs -0 rm -f
        find "$(eval_gettext '$GSH_HOME/Garden')" -iname "*$(gettext "chest")*" -type f -print0 | xargs -0 rm -f
        find "$(eval_gettext '$GSH_HOME/Garden')" -iname "*$(gettext "hut")*" -type f -print0 | xargs -0 rm -f
        ;;
esac
