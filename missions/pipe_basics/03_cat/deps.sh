if [ ! -f "$GSH_MISSIONS_BIN/install_potion_book.sh" ]
then
  echo "$(eval_gettext 'Dummy mission "pipe_basics/00_shared" is required for $MISSION_NAME.')"
  false
fi
