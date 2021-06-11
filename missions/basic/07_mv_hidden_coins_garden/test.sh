#!/bin/sh

mv "$(eval_gettext '$GSH_HOME/Garden')/".*_"$(gettext "coin")_2" "$GSH_CHEST"
gsh assert check false

mv "$(eval_gettext '$GSH_HOME/Garden')/".*_"$(gettext "coin")_1" \
   "$(eval_gettext '$GSH_HOME/Garden')/".*_"$(gettext "coin")_3" "$GSH_CHEST"
gsh assert check false

cp "$(eval_gettext '$GSH_HOME/Garden')/".*_"$(gettext "coin")_1" "$(eval_gettext '$GSH_HOME/Garden')/.$(gettext "coin")_1_truc"
gsh assert check false

cp "$(eval_gettext '$GSH_HOME/Garden')/".*_"$(gettext "coin")_1" "$(eval_gettext '$GSH_HOME/Garden')/.truc_$(gettext "coin")_1"
mv "$(eval_gettext '$GSH_HOME/Garden')/".*_"$(gettext "coin")_"* "$GSH_CHEST"
gsh assert check false

cp "$(eval_gettext '$GSH_HOME/Garden')/".*_"$(gettext "coin")_"* "$GSH_CHEST"
gsh assert check false

mv "$(eval_gettext '$GSH_HOME/Garden')/".*_"$(gettext "coin")_"* "$GSH_CHEST"
gsh assert check true
