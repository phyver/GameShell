cd "$(eval_gettext '$GSH_HOME/Mountain/Cave')"

history -s "nl \"$(eval_gettext '$MISSION_DIR/recipe/en.txt')\" | tail -n 7 | fold -s -w50"
history -s gsh check
gsh assert check true
history -d -2--1

history -s "nl \"$(eval_gettext '$MISSION_DIR/recipe/en.txt')\" | tail -n 7 | fold -s"
history -s gsh check
gsh assert check false
history -d -2--1

history -s "nl \"$(eval_gettext '$MISSION_DIR/recipe/en.txt')\" | tail -n 7 | fold -w50"
history -s gsh check
gsh assert check false
history -d -2--1

history -s "nl \"$(eval_gettext '$MISSION_DIR/recipe/en.txt')\" | fold -s -w50 | tail -n7"
history -s gsh check
gsh assert check false
history -d -2--1

history -s "tail -n7 \"$(eval_gettext '$MISSION_DIR/recipe/en.txt')\" | nl | fold -s -w50"
history -s gsh check
gsh assert check false
history -d -2--1

