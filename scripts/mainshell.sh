#!/bin/sh

# this file must be SOURCED, it will return 0 (true) if the current PID is the
# same as $$, and 1 (false) otherwise
# cf https://unix.stackexchange.com/questions/484442/how-can-i-get-the-pid-of-a-subshell

test "$( exec sh -c 'echo $PPID' )" = "$$"
