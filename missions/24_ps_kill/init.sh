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
    cp "$MISSION_DIR/cat-generator.py" "$GASH_MISSION_DATA/cat-generator"
else
    cp "$MISSION_DIR/cat-generator.sh" "$GASH_MISSION_DATA/cat-generator"
fi
chmod 755 "$GASH_MISSION_DATA/cat-generator"
"$GASH_MISSION_DATA/cat-generator" "$(eval_gettext '$GASH_HOME/Castle/Kitchen')/$(gettext "Pantry")" "$(gettext "wind-up_cat")" &
disown
