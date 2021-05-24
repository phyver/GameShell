if ! [ -e "$MISSION_DIR/ascii-art" ]
then
  DUMMY_MISSION=$(basename "$(dirname "$(realpath "$MISSION_DIR/ascii-art")")")
  echo "$(eval_gettext "Dummy mission '\$DUMMY_MISSION' is required for mission \$MISSION_NB (\$MISSION_NAME).")"
  unset DUMMY_MISSION
  false
fi
