case "$GSH_LAST_ACTION" in
    check_true | skip)
        :
        ;;
    *)
        great_hall=$(eval_gettext '$GSH_HOME/Castle/Great_hall')
        rm -f "$great_hall"/*"$(gettext "stag_head")"*
        rm -f "$great_hall"/*"$(gettext "decorative_shield")"*
        rm -f "$great_hall"/*"$(gettext "suit_of_armour")"*
        rm -f "$GSH_CHEST"/*"$(gettext "stag_head")"*
        rm -f "$GSH_CHEST"/*"$(gettext "decorative_shield")"*
        rm -f "$GSH_CHEST"/*"$(gettext "suit_of_armour")"*
        ;;
esac
