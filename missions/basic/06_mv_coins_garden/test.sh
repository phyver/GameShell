#!/usr/bin/env sh

mv "$(eval_gettext '$GSH_HOME/Garden')/$(gettext "coin")_"2 "$GSH_CHEST"
gsh assert check false

mv "$(eval_gettext '$GSH_HOME/Garden')/$(gettext "coin")_1" \
   "$(eval_gettext '$GSH_HOME/Garden')/$(gettext "coin")_3" "$GSH_CHEST"
gsh assert check false

mv "$(eval_gettext '$GSH_HOME/Garden')/$(gettext "coin")_"? "$GSH_CHEST"
gsh assert check true
