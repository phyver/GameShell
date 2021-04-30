rm -f "$GASH_MISSION_DATA"/generator
rm -f "$GASH_MISSION_DATA"/rat_poison*
rm -f "$GASH_MISSION_DATA"/cheese*
killall -s SIGKILL -q tail generator linguini.sh skinner.sh
