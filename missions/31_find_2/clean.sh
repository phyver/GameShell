maze="$(eval_gettext '$GASH_HOME/Garden/.Maze')"
case $PWD in
    "$maze"/?*)
        cd "$maze"
        echo "$(gettext "You are back at the entrance of the maze...")"
        ;;
esac

rm -f "$GASH_MISSION_DATA/ruby"
rm -rf "$maze"/*
