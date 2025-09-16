#!/usr/bin/env sh

_mission_check() (
  SDBA="$GSH_HOME/dev/sda"
  SDBB="$GSH_HOME/dev/sdb"

  # 1) Vérifier que les chemins existent
  if [ ! -e "$SDBA" ]; then
    echo "$(eval_gettext "Device \$SDBA does not exist.")"
    return 1
  fi
  if [ ! -e "$SDBB" ]; then
    echo "$(eval_gettext "Device \$SDBB does not exist.")"
    return 1
  fi

  # 2) Vérifier que ce sont des PV LVM
  #    pvs renvoie un code d'erreur si l'argument n'est pas un PV
  if ! danger sudo pvs --noheadings "$SDBA" >/dev/null 2>&1; then
    echo "$(eval_gettext "Vous devez encore incarner le territoire éthéré d'Esdea en terre physiques !")"
    return 1
  fi

  if ! danger sudo pvs --noheadings "$SDBB" >/dev/null 2>&1; then
    echo "$(eval_gettext "Vous devez encore incarner le territoire éthéré d'Esdebe en terre physiques !")"
    return 1
  fi

  # 3) Optionnel : afficher un résumé pour le debug (non bloquant)
  #    Décommentez si utile :
  # pvs -o pv_name,vg_name,pv_size,vg_uuid --noheadings "$SDBA" "$SDBB" 2>/dev/null | sed 's/^ *//'

  echo "$(eval_gettext "Bravo, les territoires éthérés d'Esdea et d'Esdebe ont été incarnés en terres physiques !")"
  return 0
)

_mission_check
