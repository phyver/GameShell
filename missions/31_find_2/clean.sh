maze="$(eval_gettext '$GASH_HOME/Botanical_garden/.Maze')"
case $PWD in
    "$maze"/?*)
        cd "$maze"
        echo "$(gettext "Pffft... You are back to the entrance of the maze...")"
        ;;
esac

rm -f "$GASH_MISSION_DATA/ruby"
rm -rf "$maze"/*
