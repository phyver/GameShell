#!/bin/bash

dir=$(eval_gettext '$GASH_HOME/Castle/Kitchen')/$(gettext "Pantry")
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

cat "$dir"/* | checksum > "$GASH_MISSION_DATA"/pantry

if [ -x /usr/bin/python3 ]
then
    cp "$MISSION_DIR/cat-generator.py" "$MISSION_DIR/cat-generator"
else
    cp "$MISSION_DIR/cat-generator.sh" "$MISSION_DIR/cat-generator"
fi
"$MISSION_DIR/cat-generator" "$(eval_gettext '$GASH_HOME/Castle/Kitchen')/$(gettext "Pantry")" "$(gettext "wind-up_cat")" &
disown
