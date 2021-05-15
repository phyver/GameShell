# NOTE: --literal doesn't exist in freebsd
if ls --literal / &> /dev/null
then
    alias ls='ls --literal -p --color=auto'
else
    alias ls='ls -p --color=auto'
fi
