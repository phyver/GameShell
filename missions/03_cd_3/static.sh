dir="$(eval_gettext '$GASH_HOME/Castle/Main_building/Throne_room')"
mkdir -p "$dir"
mkdir -p "$dir/$(gettext "Kings_quarter")"
cat <<EOK>"$dir/$(gettext "Kings_quarter")/$(gettext "crown")"
  _.+._
(^\/^\/^)
 \@*@*@/
 {_____}
EOK
chmod -R -w "$dir/$(gettext "Kings_quarter")"
unset dir
