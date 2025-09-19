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

  # 3) Vérifier que les VG 'esdea' et 'esdebe' existent
  if ! danger sudo vgs --noheadings -o vg_name | grep -qw esdea; then
    echo "$(eval_gettext "La Colonie d’Esdea n’a pas encore été fondée !")"
    return 1
  fi
  if ! danger sudo vgs --noheadings -o vg_name | grep -qw esdebe; then
    echo "$(eval_gettext "La Colonie d’Esdebe n’a pas encore été fondée !")"
    return 1
  fi

  # 4) Vérifier la correspondance PV↔VG
  #    - /dev/sda doit appartenir à VG 'esdea'
  #    - /dev/sdb doit appartenir à VG 'esdebe'
  ESDEA_VG="$(danger sudo pvs --noheadings -o vg_name "$SDBA" 2>/dev/null | tr -d '[:space:]')"
  ESDEBE_VG="$(danger sudo pvs --noheadings -o vg_name "$SDBB" 2>/dev/null | tr -d '[:space:]')"

  if [ "$ESDEA_VG" != "esdea" ]; then
    [ -z "$ESDEA_VG" ] && ESDEA_VG="(aucun VG)"
    echo "$(eval_gettext "Incohérence : \$SDBA appartient à '\$ESDEA_VG' au lieu de 'esdea'.")"
    return 1
  fi
  if [ "$ESDEBE_VG" != "esdebe" ]; then
    [ -z "$ESDEBE_VG" ] && ESDEBE_VG="(aucun VG)"
    echo "$(eval_gettext "Incohérence : \$SDBB appartient à '\$ESDEBE_VG' au lieu de 'esdebe'.")"
    return 1
  fi

  echo "$(eval_gettext "Bravo, les colonies d’Esdea et d’Esdebe sont désormais fondées !")"
  return 0
)

_mission_check
