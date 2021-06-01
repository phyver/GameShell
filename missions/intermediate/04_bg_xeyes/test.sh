history -s "xeyes"
history -s "xeyes &"
gsh assert check false
n=$(history | tail -n1 | awk '{print $1}')
history -d $((n-1))
history -d $((n-1))
unset n

history -s "xeyes"
history -s "xeyes &"
history -s "something1"
history -s "something2"
history -s "something3"
history -s "something4"
gsh assert check false
n=$(history | tail -n1 | awk '{print $1}')
history -d $((n-5))
history -d $((n-5))
history -d $((n-5))
history -d $((n-5))
history -d $((n-5))
history -d $((n-5))
unset n

history -s "xeyes &"
history -s "xeyes"
gsh assert check false
n=$(history | tail -n1 | awk '{print $1}')
history -d $((n-1))
history -d $((n-1))
unset n

xeyes &
history -s "xeyes &"
history -s "xeyes"
gsh assert check true
n=$(history | tail -n1 | awk '{print $1}')
history -d $((n-1))
history -d $((n-1))
unset n

ps -e | awk '/xeyes/ {print $1}' | xargs kill -9 2> /dev/null


