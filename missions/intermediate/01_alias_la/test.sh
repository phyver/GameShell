#!/bin/sh

alias la="ls -A"
gsh assert check true
unalias la 2>/dev/null

alias la="  ls  	  -A  "
gsh assert check true
unalias la 2>/dev/null

alias la="ls -a"
gsh assert check false
unalias la 2>/dev/null

alias LA="ls -a"
gsh assert check false
unalias LA 2>/dev/null
