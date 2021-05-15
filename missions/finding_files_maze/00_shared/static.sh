mkdir -p "$(eval_gettext '$GSH_HOME/Garden/Maze')"
mkdir -p "$(eval_gettext '$GSH_HOME/Garden/Flower_garden')"
mkdir -p "$(eval_gettext '$GSH_HOME/Garden/Shed')"

sign_file "$MISSION_DIR/ascii-art/bucket.txt" "$(eval_gettext '$GSH_HOME/Garden/Shed')/$(gettext "bucket")"
sign_file "$MISSION_DIR/ascii-art/flowers.txt" "$(eval_gettext '$GSH_HOME/Garden/Flower_garden')/$(gettext "flowers")"

