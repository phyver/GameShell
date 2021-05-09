rm -f "$GSH_VAR"/generator
rm -f "$GSH_VAR"/rat_poison*
rm -f "$GSH_VAR"/cheese*
ps -e | awk '/tail|generator|linguini.sh|skinner.sh/ {print $1}' | xargs kill -9 2> /dev/null
