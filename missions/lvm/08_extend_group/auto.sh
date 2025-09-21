#!/usr/bin/env sh

danger sudo pvcreate "$GSH_HOME/dev/sdc"
danger sudo vgextend esdebe "$GSH_HOME/dev/sdc"
danger sudo lvcreate -L 10M -n oljoliptichaaah esdebe
