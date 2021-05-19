if ! command -v install_potion_book.sh &> /dev/null
then
  DUMMY_MISSION=$(basename "$(dirname "$MISSION_DIR")")/00_shared
  echo "$(eval_gettext 'Dummy mission "$DUMMY_MISSION" is required for mission $MISSION_NB ($MISSION_NAME).')"
  unset DUMMY_MISSION
  false
fi
