alias "$(gettext "journal")"="nano $GSH_CHEST/$(gettext "journal").txt"

if [ ! -f "$GSH_CHEST/bashrc" ]
then
  cp "$(eval_gettext '$MISSION_DIR/bashrc/en.sh')" "$GSH_CHEST/bashrc"
fi

if [ -f "$GSH_CHEST/bashrc" ]
then
  source "$GSH_CHEST/bashrc"
fi
