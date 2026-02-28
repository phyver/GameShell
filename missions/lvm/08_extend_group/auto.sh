#!/usr/bin/env sh

danger sudo pvcreate "/dev/gsh_sdc"
danger sudo vgextend esdebe "/dev/gsh_sdc"
danger sudo lvcreate -L 10M -n oljoliptichaaah esdebe
