mission_source "$MISSION_DIR/clean0.sh"

rm -f "$GSH_VAR/great_hall_contents"

case "$GSH_LAST_ACTION" in
    check_true | skip)
        :
        ;;
    *)
        great_hall="$(eval_gettext '$GSH_HOME/Castle/Great_hall')"
        rm -f "$great_hall/*$(gettext "standard")*"
        rm -f "$GSH_CHEST"/*"$(gettext "standard")"*
        unset great_hall
        ;;
esac

