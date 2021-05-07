maze="$(eval_gettext '$GSH_HOME/Garden/.Maze')"
case $PWD in
    "$maze"/?*)
        cd "$maze"
        echo "$(gettext "You are back at the entrance of the maze...")"
        ;;
esac

rm -f "$GSH_VAR/diamond"
rm -rf "$maze"/*
