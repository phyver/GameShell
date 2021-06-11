#!/bin/sh

_mission_init() (
  if ! command -v install_potion_book.sh >/dev/null
  then
    DUMMY_MISSION=$(missionname ../00_shared)
    echo "$(eval_gettext "Dummy mission '\$DUMMY_MISSION' is required for mission \$MISSION_NB (\$MISSION_NAME).")" >&2
    return 1
  fi

  # Install the book for the mission.
  install_potion_book.sh book "$(eval_gettext '$GSH_HOME/Mountain/Cave')/"

  # Install a copy for later checks. TODO: only do that in the check file?
  install_potion_book.sh book "$GSH_TMP/book_of_potions"

  # put Servillus in the cave
  rm -f "$(eval_gettext '$GSH_HOME/Mountain/Cave')/$(gettext "cauldron")"
  sign_file "$MISSION_DIR/../00_shared/ascii-art/servillus.txt" "$(eval_gettext '$GSH_HOME/Mountain/Cave')/servillus"

  return 0
)

_mission_init
