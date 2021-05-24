if ! [ -e "$MISSION_DIR/init0.sh" ]
then
  DUMMY_MISSION=$(missionname "$MISSION_DIR/init0.sh")
  echo "$(eval_gettext "Dummy mission '\$DUMMY_MISSION' is required for mission \$MISSION_NB (\$MISSION_NAME).")"
  unset DUMMY_MISSION
  false
fi
