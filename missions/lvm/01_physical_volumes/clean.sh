#!/usr/bin/env sh

# Do nothing we need to keep the loop devices and the disk images
# for the next missions in the LVM series.

if $GSH_LAST_ACTION != "check_true"
then
  echo "$(eval_gettext "Aucune action n'est nécessaire dans ce script de nettoyage, les volumes logiques doivent être conservés pour les missions suivantes.")"
fi

return 0