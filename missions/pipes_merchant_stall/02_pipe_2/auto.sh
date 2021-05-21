# beware, there are so many files that we may get "bash: /usr/bin/grep: Argument list too long"
# so we use recursive grep on the diectory instead of globbing
gsh check < <(grep -rv "$(gettext "PAID")" "$(eval_gettext '$GSH_HOME/Stall')" | wc -l)
