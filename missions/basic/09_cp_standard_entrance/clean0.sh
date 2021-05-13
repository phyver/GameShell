case "$GSH_LAST_ACTION" in
    check_true | skip)
        :
        ;;
    *)
        entrance=$(eval_gettext '$GSH_HOME/Castle/Entrance')
        rm -f "$entrance"/*"$(gettext "stag_head")"*
        rm -f "$entrance"/*"$(gettext "decorative_shield")"*
        rm -f "$entrance"/*"$(gettext "suit_of_armour")"*
        rm -f "$GSH_CHEST"/*"$(gettext "stag_head")"*
        rm -f "$GSH_CHEST"/*"$(gettext "decorative_shield")"*
        rm -f "$GSH_CHEST"/*"$(gettext "suit_of_armour")"*
        ;;
esac
