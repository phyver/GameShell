maze="$(eval_gettext '$GASH_HOME/Botanical_garden/.Maze')"
case $PWD in
    "$maze"/?*)
        cd "$maze"
        echo "$(gettext "You are back at the entrance of the maze...")"
        ;;
esac

rm -f "$GASH_MISSION_DATA/silver_coin"
rm -rf "$maze"/*
