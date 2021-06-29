#!/bin/sh

safe="$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')/$(gettext "Safe")"

case "$GSH_LAST_ACTION" in
  "check_true")
    :
    ;;
  *)
    _PWD="$(readlink-f $(pwd) 2>/dev/null)"
    if [ -n "$_PWD" ] && [ "$_PWD" = "$(readlink-f "$safe" 2>/dev/null)" ]
    then
      cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
    fi
    unset _PWD
    ;;
esac

# avoid problems when making a tar archive
chmod 755 "$safe"
chmod -f 644 "$safe/$(gettext "crown")" 2>/dev/null
rm -f "$GSH_TMP/crown"
unset safe
