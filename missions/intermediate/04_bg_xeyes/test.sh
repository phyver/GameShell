history -s "xeyes"
history -s "xeyes &"
gsh assert check false
history -d -2--1

history -s "xeyes"
history -s "xeyes &"
history -s "something1"
history -s "something2"
history -s "something3"
history -s "something4"
gsh assert check false
history -d -6--1

history -s "xeyes &"
history -s "xeyes"
gsh assert check false
history -d -2--1

xeyes &
history -s "xeyes &"
history -s "xeyes"
gsh assert check true
history -d -2--1

ps -e | awk '/xeyes/ {print $1}' | xargs kill -9 2> /dev/null


