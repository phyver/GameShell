if [ ! -f "$GSH_MISSIONS_SBIN/install_potion_book.sh" ]
then
    DUMMY_MISSION=$(basename "$(dirname "$MISSION_DIR")")/00_shared
    echo "$(eval_gettext 'Dummy mission "$DUMMY_MISSION" is required for mission $MISSION_NB ($MISSION_NAME).')"
    false
fi
