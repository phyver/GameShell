rm -f "$GSH_MISSION_DATA/cat-generator"
ps -e | awk '/cat-generator/ {print $1}' | xargs kill -9 2> /dev/null
