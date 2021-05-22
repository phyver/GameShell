if ! command -v maze2.sh &> /dev/null
then
  DUMMY_MISSION=$(realpath "$MISSION_DIR/../00_shared")
  DUMMY_MISSION=${DUMMY_MISSION#$GSH_MISSIONS/}
  echo "$(eval_gettext 'Dummy mission "$DUMMY_MISSION" is required for mission $MISSION_NB ($MISSION_NAME).')"
  unset DUMMY_MISSION
  false
fi
