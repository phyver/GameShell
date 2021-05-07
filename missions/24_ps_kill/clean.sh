rm -f "$GSH_VAR/cat-generator"
ps -e | awk '/cat-generator/ {print $1}' | xargs kill -9 2> /dev/null
rm -f "$GSH_VAR/cat-generator.pid"
