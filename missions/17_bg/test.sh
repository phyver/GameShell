history -s "xeyes"
history -s "xeyes &"
gash assert check false
history -d -2--1

history -s "xeyes"
history -s "xeyes &"
history -s "something1"
history -s "something2"
history -s "something3"
history -s "something4"
gash assert check false
history -d -6--1

history -s "xeyes &"
history -s "xeyes"
gash assert check false
history -d -2--1

xeyes &
history -s "xeyes &"
history -s "xeyes"
gash assert check true
history -d -2--1

killall -q -9 xeyes


