#!/usr/bin/env sh

danger sudo lvchange -an /dev/esdebe/oljoliptichaaah esdebe
danger sudo lvremove -f /dev/esdebe/oljoliptichaaah
danger sudo vgreduce esdebe "$GSH_HOME/dev/sdc"
danger sudo pvremove "$GSH_HOME/dev/sdc"
