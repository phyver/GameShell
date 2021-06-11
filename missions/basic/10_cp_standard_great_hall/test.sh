#!/bin/sh

cp "$(eval_gettext '$GSH_HOME/Castle/Great_hall')/$(gettext "standard")"_? "$GSH_CHEST"
gsh assert check true

mv "$(eval_gettext '$GSH_HOME/Castle/Great_hall')/$(gettext "standard")"_? "$GSH_CHEST"
gsh assert check false

cp "$(eval_gettext '$GSH_HOME/Castle/Great_hall')"/* "$GSH_CHEST"
gsh assert check false

gsh assert check false

cp "$(eval_gettext '$GSH_HOME/Castle/Great_hall')/$(gettext "standard")"_? "$GSH_CHEST"
rm "$(eval_gettext '$GSH_HOME/Castle/Great_hall')"/*"$(gettext "stag_head")"*
gsh assert check false

