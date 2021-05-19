#!/bin/bash

# mission originaly created by Tiemen Duvillard

_mission_init() {
  local SECRET_KEY=$(random_string 4 | tr A-Z a-z)
  # FIXME, only store hash of key?
  echo "$SECRET_KEY" > "$GSH_VAR/secret_key"

  local random_shift=$((12 + RANDOM % 3))

  local ab=abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz
  local D=${ab:random_shift:26}

  echo "$(eval_gettext "here is my will:
you will get my chest, and everything it contains.
this check is in the cellar, and the key to make
it re-appear is: \$SECRET_KEY
merlin the enchanter")" | tr "a-z" "$D" > "$(eval_gettext '$GSH_HOME/Castle/Main_building/Library/Merlin_s_office/Drawer')/$(gettext 'secret_message')"
}

_mission_init
