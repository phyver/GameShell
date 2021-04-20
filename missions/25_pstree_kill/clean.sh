#!/bin/bash

exec 3>&2          # 3 is now a copy of 2
exec 2> /dev/null  # 2 now points to /dev/null
killall -s SIGKILL -q tail generator.sh generator.py felix.sh gros_minet.sh
sleep 1            # sleep to wait for process to die
exec 2>&3          # restore stderr to saved
exec 3>&-          # close saved version

