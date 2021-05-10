ps -e | awk '/spell/ {print $1}' | xargs kill 2> /dev/null
ps -e | awk '/spell/ {print $1}' | xargs kill -9 2> /dev/null
gsh check
