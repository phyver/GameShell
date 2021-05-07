rm -f "$GSH_MISSION_DATA"/generator
rm -f "$GSH_MISSION_DATA"/rat_poison*
rm -f "$GSH_MISSION_DATA"/cheese*
ps -e | awk '/tail|generator|linguini.sh|skinner.sh/ {print $1}' | xargs kill -9 2> /dev/null
