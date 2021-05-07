export YYYY=$(cut -d"-" -f1 "$GSH_MISSION_DATA"/date)
export MM=$(cut -d"-" -f2 "$GSH_MISSION_DATA"/date)
export DD=$(cut -d"-" -f3 "$GSH_MISSION_DATA"/date)
envsubst '$YYYY $MM $DD' < "$(eval_gettext '$MISSION_DIR/goal/en.txt')"
unset YYYY MM DD
