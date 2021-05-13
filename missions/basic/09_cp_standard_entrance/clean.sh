mission_source "$MISSION_DIR/clean0.sh"

rm -f "$GSH_VAR/entrance_contents"

case "$GSH_LAST_ACTION" in
    check_true | skip)
        :
        ;;
    *)
        entrance="$(eval_gettext '$GSH_HOME/Castle/Entrance')"
        rm -f "$entrance/*$(gettext "standard")*"
        rm -f "$GSH_CHEST"/*"$(gettext "standard")"*
        ;;
esac

