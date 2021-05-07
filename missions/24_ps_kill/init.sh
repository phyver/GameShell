#!/bin/bash

dir=$(eval_gettext '$GSH_HOME/Castle/Kitchen')/$(gettext "Pantry")
cat > "$dir/$(gettext "barrel_of_apples")" <<'EOF'

  ,--./,-.
 / #      \
|          |
 \        /
  `._,._,'

EOF

cat > "$dir/$(gettext "piece_of_cheese")" <<'EOF'
       ___ _____
      /\ (_)    \
     /  \      (_,
    _)  _\   _    \
   /   (_)\_( )____\
   \_     /    _  _/
     ) /\/  _ (o)(
     \ \_) (o)   /
      \/________/

EOF

cat "$dir"/* | checksum > "$GSH_VAR"/pantry

if [ -x /usr/bin/python3 ]
then
    cp "$MISSION_DIR/cat-generator.py" "$GSH_VAR/cat-generator"
else
    cp "$MISSION_DIR/cat-generator.sh" "$GSH_VAR/cat-generator"
fi
chmod 755 "$GSH_VAR/cat-generator"
"$GSH_VAR/cat-generator" "$(eval_gettext '$GSH_HOME/Castle/Kitchen')/$(gettext "Pantry")" "$(gettext "wind-up_cat")" &
echo $! > "$GSH_VAR"/cat-generator.pid
disown
