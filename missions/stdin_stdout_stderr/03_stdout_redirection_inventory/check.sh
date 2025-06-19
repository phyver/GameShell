#!/usr/bin/env sh

_mission_check() (
  office="$(eval_gettext '$GSH_HOME/Castle/Main_building/Library/Merlin_s_office')"
  inventory_file="$(gettext "inventory.txt")"

  if [ ! -f "$office/$(gettext "Drawer")/$inventory_file" ]
  then
    echo "$(eval_gettext 'There is no $inventory_file in the drawer...')"
    return 1
  fi

  temp_file=$(mktemp)
  sort "$office/$(gettext "Drawer")/$inventory_file" >"$temp_file"
  if ! cmp -s "$temp_file" "$GSH_TMP/inventory_grimoires"
  then
    # FIXME: fail if inventory contains
    #   ./book...
    # instead of
    #   book...
    # display a specific message in that case
    echo "$(eval_gettext 'The content of $inventory_file is invalid.
You can check its content with the command
    § less $inventory_file')" |  sed 's/§/\$/'
    rm -f "$temp_file"
    return 1
  fi
  rm -f "$temp_file"
  return 0
)

_mission_check
