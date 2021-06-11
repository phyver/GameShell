alias "$(gettext "journal")"="nano $GSH_CHEST/$(gettext "journal").txt"

if [ ! -f "$GSH_CHEST/gshrc" ]
then
  cp "$(eval_gettext '$MISSION_DIR/gshrc/en.sh')" "$GSH_CHEST/gshrc"
fi

if [ -f "$GSH_CHEST/gshrc" ]
then
  . "$GSH_CHEST/gshrc"
fi
