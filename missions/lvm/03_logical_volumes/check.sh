#!/usr/bin/env sh

check_lv_size() {
    VG_LV="$1"       # e.g. esdea/ouskelcoule
    TARGET="$2"      # requested size in Mo (e.g. 50)
    TOLERANCE="${3:-4}"  # default = 4 Mo

    # Extract actual size (in Mo, without "m")
    ACTUAL="$(danger sudo lvs "$VG_LV" --noheadings -o lv_size --units m \
              | awk '{gsub(/m/,""); gsub(/^ +| +$/,""); print $1}')"

    # Compute difference
    DIFF=$(awk -v act="$ACTUAL" -v tgt="$TARGET" 'BEGIN{ d=act-tgt; if(d<0)d=-d; print d }')

    # Check within tolerance
    RESULT=$(awk -v diff="$DIFF" -v tol="$TOLERANCE" 'BEGIN{ exit (diff <= tol ? 0 : 1) }')
    return $RESULT
}

_mission_check() (
  
  # Check that the logical volumes exist with the correct sizes
  if ! check_lv_size esdea/ouskelcoule 20; then
    echo "$(eval_gettext "Le village d'Ouskelcoule n'est pas présent ou n'a pas la bonne taille (50 Mo).")"
    return 1
  fi

  if ! check_lv_size esdea/douskelpar 10; then
    echo "$(eval_gettext "Le village de Douskelpar n'est pas présent ou n'a pas la bonne taille (20 Mo).")"
    return 1
  fi

  if ! check_lv_size esdebe/grandflac 15; then
    echo "$(eval_gettext "Le village de Grandflac n'est pas présent ou n'a pas la bonne taille (30 Mo).")"
    return 1
  fi

  echo "$(eval_gettext "Bravo, les frontières des villages d'Ouskelcoule, de Douskelpar et de Grandflac sont désormais tracées !")"
  return 0
)

_mission_check
