#!/bin/bash

# ``history`` command is not in POSIX

history -s "xeyes"
history -s "xeyes &"
xeyes &
gsh check

# macOS' version of bash is too old and we cannot delete ranges of commands in
# history
n=$(history | tail -n1 | awk '{print $1}')
history -d $((n-1))
history -d $((n-1))
unset n
