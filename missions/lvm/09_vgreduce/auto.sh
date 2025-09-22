#!/usr/bin/env sh

danger sudo lvchange -an /dev/esdebe/oljoliptichaaah esdebe
danger sudo lvremove -f /dev/esdebe/oljoliptichaaah
danger sudo vgreduce esdebe "/dev/gsh_sdc"
danger sudo pvremove "/dev/gsh_sdc"
