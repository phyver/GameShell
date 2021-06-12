#!/bin/sh

cp "$(eval_gettext '$GSH_HOME/Castle/Great_hall')/$(gettext "standard")"_? "$GSH_CHEST"
gsh check
