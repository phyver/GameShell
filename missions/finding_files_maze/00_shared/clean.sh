maze="$(eval_gettext '$GSH_HOME/Garden/Maze')"
case $PWD in
    "$maze"/?*)
        cd "$maze"
        echo "$(gettext "You are back at the entrance of the maze...")"
        ;;
esac

case "$maze" in
  */World/*)
    rm -rf "$maze"/?*
    ;;
  *)
    echo "Error: I don't want to remove the content of $maze!"
    exit 1
    ;;
esac
unset maze
