alias la="ls -A"
gsh assert check true
unalias la

alias la="  ls  	  -A  "
gsh assert check true
unalias la

alias la="ls -a"
gsh assert check false

alias LA="ls -a"
gsh assert check false
unalias LA
