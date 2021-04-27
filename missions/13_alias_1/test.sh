alias la="ls -A"
gash assert check true
unalias la

alias la="  ls  	  -A  "
gash assert check true
unalias la

alias la="ls -a"
gash assert check false

alias LA="ls -a"
gash assert check false
unalias LA
